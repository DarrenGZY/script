--[[
Title:check the globalestore and extendcost.

use lib:
----------------------------------------------
NPL.load("(gl)script/apps/Aries/Debug/DatabaseChecker.lua");
local DataBaseChecker = commonlib.gettable("MyCompany.Aries.Debug.Checker.DataBaseChecker");
DataBaseChecker.CheckDB(false);
----------------------------------------------
]]

--MyCompany.Aries.Debug.Checker = MyCompany.Aries.Debug.Checker or {};
local DataBaseChecker = commonlib.gettable("MyCompany.Aries.Debug.Checker.DataBaseChecker");

local GSIDRegionFilePath, EXIDRegionFilePath;
if(System.options.version == "kids") then
	GSIDRegionFilePath = "config/Aries/GlobalStore.IDRegions.xml";
	EXIDRegionFilePath = "config/Aries/ExtendedCost.IDRegions.xml";
end
if(System.options.version == "teen") then
	GSIDRegionFilePath = "config/Aries/GlobalStore.IDRegions.teen.xml";
	EXIDRegionFilePath = "config/Aries/ExtendedCost.IDRegions.teen.xml";
end

function DataBaseChecker.CheckDB()
	--log("begin the checkDB\n");
	local res = "";
	local globalstoreRes = "";
	local extendedcostRes = "";
	--echo("22222222222222222");
	globalstoreRes = DataBaseChecker.CheckGlobalStore();

	res = res..globalstoreRes;
	
	if(res == "") then
		res = "globalstore检查无误";
	end
	--log("end the checkDB");
	--echo(DataBaseChecker.DataRecord.globalstore.card);
	return res;
end

local function checkClass(itemValue,gsidTable)
	local res = "";
	local class = gsidTable.template.class;
	local subclass = gsidTable.template.subclass;
	if(class == 18 and (subclass == 1 or subclass == 2)) then
		gsidTable.type = "card";
		local _,_,cardKey = string.find(gsidTable.assetfile,"%d+%_(.*)");
		if(cardKey ~= nil) then
			if(DataBaseChecker.DataRecord.globalstore.card[cardKey] == nil) then
				DataBaseChecker.DataRecord.globalstore.card[cardKey] = {};
				DataBaseChecker.DataRecord.globalstore.card[cardKey]["gsid"] =  gsidTable.gsid;
				DataBaseChecker.DataRecord.globalstore.card[cardKey]["name"] =  gsidTable.template.name;

			end
		else
		end
	end
	
	return res;
end

function DataBaseChecker.CheckGlobalStore()
	local res = "";
	local regionItemXPath = "/gsidregions/region";
	local regionXMLTable = ParaXML.LuaXML_ParseFile(GSIDRegionFilePath);
	local regionItem;
	for regionItem in commonlib.XPath.eachNode(regionXMLTable,regionItemXPath) do
		if(regionItem.attr.version == System.options.version) then
			local fromID = tonumber(regionItem.attr.from);
			local toID = tonumber(regionItem.attr.to);

			for gsid = fromID,toID do
				local gsidCheckRes = "";
				local checkItem, functionName;
				local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(gsid);

				if(gsItem ~= nil) then
					checkClass(gsItem.template.class,gsItem);

					for checkItem, functionName in pairs(DataBaseChecker.GlobalStoreCheck.templateItem) do
						gsidCheckRes = gsidCheckRes..functionName(gsItem.template[checkItem],gsItem);
					end
					for checkItem, functionName in pairs(DataBaseChecker.GlobalStoreCheck.baseItem) do
						gsidCheckRes = gsidCheckRes..functionName(gsItem[checkItem],gsItem);
					end
				else
					gsidCheckRes = gsidCheckRes.."该GSID在数据库中不存在\n";
					break;
				end
				if(gsidCheckRes ~= "") then
					gsidCheckRes = gsid.."检查有误，错误如下：\n"..gsidCheckRes.."\n";
				end
				res = res..gsidCheckRes;
				
			end

		end
	end
	return res;
end

function DataBaseChecker.checkExcel()

	local function readExcel()
		local excelTable = {
			excelColumn = {},   -- 存储excel中登记的gsid中数据项的名称
			rowsTable = {},     -- 存储excel中填写的gsid的各项数据值
		};
		local excelPath = "config/Aries/Check/subcheck.xml";
		local excelXML = ParaXML.LuaXML_ParseFile(excelPath);
		local rowNode;
		local index = 1;

		for rowNode in commonlib.XPath.eachNode(excelXML,"/Workbook/Worksheet/Table/Row") do
		--echo(rowNode);
			if(rowNode.attr) then
				if(rowNode.attr["ss:Index"]) then
					index = tonumber(rowNode.attr["ss:Index"]);
				end
			end
			local columnIndex = 1;
			local cellNode;
			local cellData;
			local value;
			if(index >= 10) then
				if(index == 10) then
					for cellNode in commonlib.XPath.eachNode(rowNode,"/Cell") do
						if(cellNode[1] and cellNode[1][1]) then
							value = string.lower(cellNode[1][1]);
							excelTable.excelColumn[columnIndex] = value;
							columnIndex = columnIndex + 1;
						end
					end 

				else
				
					local isOver = false;  -- 判断上一列是不是stat_type
					local stat_typeValue;
					-- 储存每个gsid相应的数据
					local rowTable = {
						["stats"] = {},-- 存储stats的type、value键值对
					};
					for cellNode in commonlib.XPath.eachNode(rowNode,"/Cell") do
						cellData = cellNode[1];
						if(cellNode[1] ~= nil) then
							if(type(cellNode[1][1]) ~= "string") then
								value = tostring(cellNode[1][1]);
							else
								value = cellNode[1][1];
							end
							if(cellNode.attr) then
								if(cellNode.attr["ss:Index"]) then
									columnIndex = tonumber(cellNode.attr["ss:Index"]);
								end
							end
							if(isOver or excelTable.excelColumn[columnIndex] == "stat_type") then
								if(excelTable.excelColumn[columnIndex] == "stat_type") then
									isOver = true;
									stat_typeValue = value;
									rowTable["stats"][value] = "";
								elseif(excelTable.excelColumn[columnIndex] == "stat_value") then
									rowTable["stats"][stat_typeValue] = value;
								end
							else
								rowTable[excelTable.excelColumn[columnIndex]] = value;
							end
							columnIndex = columnIndex + 1;
						end
				
					end
					if(next(rowTable["stats"]) == nil) then
						rowTable["stats"] = nil;
					end
					if(next(rowTable) ~= nil) then
						excelTable.rowsTable[index] = rowTable;
					end
				end
			end
			
			index = index + 1;
		end
		return excelTable;
	end

	local function reviewExcelTable(excelTable)
		--local statTable = {
			--stat_type = {
				--"stat_type_1","stat_type_2","stat_type_3","stat_type_4","stat_type_5","stat_type_6","stat_type_7","stat_type_8","stat_type_9","stat_type_10",
			--},
			--stat_value = {
				--"stat_value_1","stat_value_2","stat_value_3","stat_value_4","stat_value_5","stat_value_6","stat_value_7","stat_value_8","stat_value_9","stat_value_10",
			--},
		--};
		local res = "";
		local rowsTable = excelTable.rowsTable;
		local excelColumn = excelTable.excelColumn;
		local rowTable;
		for _, rowTable in pairs(rowsTable) do
			local _,fromID,toID,class,subclass;
			fromID = nil;
			toID = nil;
			class = nil;
			subclass = nil;
			if(rowTable["gsid"] ~= "") then
				if(string.find(rowTable["gsid"],"-")) then
					_,_,fromID,toID = string.find(rowTable["gsid"],"(%d+)-(%d+)");
				else
					fromID = rowTable["gsid"]; 
					toID = rowTable["gsid"];
				end
			else
				class = rowTable["class"];
				subclass = rowTable["subclass"];
			end
			if(fromID ~= nil) then
				for gsid = fromID,toID do
					local gsidCheckRes = "";
					local checkItem, functionName;
					local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(gsid);
					if(gsItem ~= nil) then
						checkClass(gsItem.template.class,gsItem);

						for checkItem, functionName in pairs(DataBaseChecker.GlobalStoreCheck.templateItem) do
							gsidCheckRes = gsidCheckRes..functionName(gsItem.template[checkItem],gsItem);
							if(checkItem == "stats") then
								local statsCheckRes = DataBaseChecker.checkStats(rowTable.stats,gsItem.template.stats)
								gsidCheckRes = gsidCheckRes..statsCheckRes;
							else
								if(rowTable[checkItem] ~= nil and rowTable[checkItem] ~= "") then
									if(tostring(gsItem.template[checkItem]) ~= tostring(rowTable[checkItem])) then
										gsidCheckRes = gsidCheckRes.."物品"..checkItem.."属性为:"..gsItem.template[checkItem].."和excel所填值:"..rowTable[checkItem].."不符\n";
									end
								end
							end
						end

						for checkItem, functionName in pairs(DataBaseChecker.GlobalStoreCheck.baseItem) do
							gsidCheckRes = gsidCheckRes..functionName(gsItem[checkItem],gsItem);
							if(rowTable[checkItem] ~= nil and rowTable[checkItem] ~= "") then
								if(tostring(gsItem[checkItem]) ~= tostring(rowTable[checkItem])) then
									gsidCheckRes = gsidCheckRes.."物品"..checkItem.."属性为:"..gsItem[checkItem].."和excel所填值:"..rowTable[checkItem].."不符\n";
								end
							end
						end
					else
						gsidCheckRes = gsidCheckRes.."该GSID在数据库中不存在\n";
						break;
					end
					if(gsidCheckRes ~= "") then
						gsidCheckRes = gsid.."检查有误，错误如下：\n"..gsidCheckRes.."\n\n";
					end
					res = res..gsidCheckRes;
					
				end
			end
		end
		return res;
	end
	echo("3333333333333333333333");
	local table = readExcel();
	echo("111111111");
	echo(table);
	local res = reviewExcelTable(table);
	if(res == "") then
		res = "globalstore检查无误";
	end
	log("end the checkDB");
	return res;
	--res = string.gsub(res,"\n","\r\n");
	--local resultFile = ParaIO.open("config/Aries/Check/excelCheckResult.txt","w");
	--if(resultFile:IsValid() ~= true) then
		--log("error: failed loading redundanceFile.txt file\n");
		--return;
	--end
	--resultFile:WriteString(res);
	--resultFile:close();
	--_guihelper.MessageBox("检查完成,检查结果请查看文件:config/Aries/Check/excelCheckResult.txt");
end

-- 只有检查excel中指定的gsid时候用到
-- @excelStatsTable excel中指定的必填的stats内容
-- @gsidStatsTable  84、85中gsid中填写的stats内容
function DataBaseChecker.checkStats(excelStatsTable,gsidStatsTable)
	local res = "";
	local type,value;
	local statType_Value,statValue_Value;
	
	for type, value in pairs(excelStatsTable) do
		local itemCheckRes = "";
		statType_Value = tonumber(type);
		if(gsidStatsTable[statType_Value]) then
			if(value ~= "") then
				statValue_Value = tonumber(value);
				if(tonumber(gsidStatsTable[statType_Value]) ~= statValue_Value) then
					itemCheckRes = itemCheckRes.."该GSID中stats的"..type.."类型的值和excel中的不符";	
				end
			end
			
		else
			itemCheckRes = itemCheckRes.."该GSID中的stats没有配置"..type.."的类型";
		end
		res = res..itemCheckRes;
	end
	return res;
end

-- 不管检查部分还是全体gsid都会用到
local function checkAssetKey(itemValue,gsidTable)
	local res = "";
	local isDesirable = true;
	local _,_,id = string.find(itemValue,"(%d+).*");
	if(id == nil) then
		isDesirable = false;
		res = res.."命名中的不包含gsid;"
	elseif(tonumber(id) ~= gsidTable.gsid) then
		isDesirable = false;
		res = res.."命名中的gsid和物品的gsid不一致;"
	end

	if(string.find(itemValue,"%s")) then
		res = res.."命名中包含空格;"
		isDesirable = false;
	end
	if(string.len(itemValue) ~= ParaMisc.GetUnicodeCharNum(itemValue)) then
		res = res.."命名中包含中文字符;"
		isDesirable = false;
	end
	if(not isDesirable) then
		res = "AssetKey命名不合格:"..res.."\n";
	end
	
	return res;
end

local function checkAssetFile(itemValue,gsidTable)
	local res = "";
	local isDesirable = true;
	if(gsidTable.type == "card") then
		if(itemValue ~= gsidTable.assetkey) then
			res = "卡牌的AssetFile必须和AssetKey一致;\n";
		end
	end
	return res;
end

local function checkDescFile(itemValue,gsidTable)
	local res = "";
	local isDesirable = true;
	if(itemValue ~= "") then	
		if(not ParaIO.DoesFileExist(itemValue)) then
			res = "DescFile填写的文件不存在;\n"
		elseif(string.find(itemValue,"%s")) then
			isDesirable = false;
		elseif(string.len(itemValue) ~= ParaMisc.GetUnicodeCharNum(itemValue)) then
			isDesirable = false;
		end
		
		if(not isDesirable) then
			res = "DescFile填写内容不合格:可能包含中文字符或者空格;\n";
		end
	end
	return res;
end

local function checkCount(itemValue,gsidTable)
	local res = "";
	local isDesirable = true;
	if(itemValue == "0") then
		res = "魔豆价格不能为0;\n"
	end
	return res;
end

local function checkIcon(itemValue,gsidTable)
	local res = "";
	local isDesirable = true;
	local iconPath = itemValue;
	if(iconPath ~= "") then	
		if(string.find(iconPath,";") ~= nil) then
			iconPath = string.sub(iconPath,1,(string.find(iconPath,";")-1));
		end
		if(not ParaIO.DoesFileExist(iconPath)) then
			res = "icon文件路径不存在;\n"
		elseif(string.find(iconPath,"%s")) then
			isDesirable = false;
		elseif(string.len(iconPath) ~= ParaMisc.GetUnicodeCharNum(iconPath)) then
			isDesirable = false;
		end
		
		if(not isDesirable) then
			res = "icon文件路径不合格:可能包含中文字符或者空格;\n";
		end
	end
	return res;
end

local function checkMaxWeeklyCount(itemValue,gsidTable)
	local res = "";
	if(tonumber(itemValue) < tonumber(gsidTable.maxdailycount)) then
		res = "每日购买上限大于每周购买上限;\n"
	end
	return res;
end

local function checkMaxCount(itemValue,gsidTable)
	local res = "";
	if(itemValue ~= gsidTable.template.maxcopiesinstack) then
		res = "MaxCount和MaxCopiesInStack必须相等;\n"
	end
	return res;
end

local function checkItemSetID(itemValue,gsidTable)
	local res = "";
	if(itemValue ~= "0") then
		if(DataBaseChecker.DataRecord.globalstore.itemset[itemValue] == nil) then
			DataBaseChecker.DataRecord.globalstore.itemset[itemValue] = 1;
		else
			DataBaseChecker.DataRecord.globalstore.itemset[itemValue] = DataBaseChecker.DataRecord.globalstore.itemset[itemValue] + 1; 
		end
	end
	return res;
end

local function empty(itemValue,gsidTable)
	local res = "";
	local isDesirable = true;

	return res;
end


DataBaseChecker.DataRecord = {
	globalstore = {
		card = {},
		itemset = {},
	},
	extendedcost = {},
};

DataBaseChecker.GlobalStoreCheck = { 
	baseItem = {
		["assetkey"] = checkAssetKey,
		["assetfile"] = checkAssetFile,
		["descfile"] = checkAsset,
		["type"] = empty,
		["category"] = empty,
		["count"] = checkCount,
		["icon"] = checkIcon,
		["pbuyprice"] = empty,
		["ebuyprice"] = empty,
		["psellprice"] = empty,
		["esellprice"] = empty,
		["esellrandombonus"] = empty,
		["requirepayment"] = empty,

		["maxdailycount"] = empty,
		["maxweeklycount"] = checkMaxWeeklyCount,

		["hourlylimitedpurchase"] = empty,
		["dailylimitedpurchase"] = empty,
		
	},
	templateItem = {
		["class"] = checkClass,
		["subclass"] = empty,
		["name"] = empty,
		["inventorytype"] = empty,
		["maxcount"] = checkMaxCount,
		["maxcopiesinstack"] = empty,
		["stackcount"] = empty,

		["stats"] = empty,
		--["stat_type_2"] = checkSatat_type,
		--["stat_type_3"] = checkSatat_type,
		--["stat_type_4"] = checkSatat_type,
		--["stat_type_5"] = checkSatat_type,
		--["stat_type_6"] = checkSatat_type,
		--["stat_type_7"] = checkSatat_type,
		--["stat_type_8"] = checkSatat_type,
		--["stat_type_9"] = checkSatat_type,
		--["stat_type_10"] = checkSatat_type,
		--["stat_value_1"] = empty,
		--["stat_value_2"] = empty,
		--["stat_value_3"] = empty,
		--["stat_value_4"] = empty,
		--["stat_value_5"] = empty,
		--["stat_value_6"] = empty,
		--["stat_value_7"] = empty,
		--["stat_value_8"] = empty,
		--["stat_value_9"] = empty,
		--["stat_value_10"] = empty,
--

		["descrition"] = empty,
		["canusedirectly"] = empty,
		["destroyafteruse"] = empty,
		["cansell"] = empty,
		["canexchange"] = empty,
		["cangift"] = empty,
		["expiretype"] = empty,
		["expiretime"] = empty,					
		["expiredate"] = empty,
		["destroyafterexpire"] = empty,
		["rechargeable"] = empty,
		["material"] = empty,
		["itemsetid"] = checkItemSetID,
		["bagfamily"] = empty,
	},
}


function DataBaseChecker.ReadExcel(path)
	if(not path) then
		path = "config/Aries/Check/subcheck.xml";
	end
	if(not ParaIO.DoesFileExist(path)) then
		LOG.std("","error","DBCheck","the excel %s dosen't exist",path);
		return;
	end 
	
	local excelXML = ParaXML.LuaXML_ParseFile(path);

	if(not excelXML) then
		LOG.std("","error","DBCheck","the excelXML table is nil");
		return;
	end

	local WorksheetNode;
	local excelTable = {};

	for WorksheetNode in commonlib.XPath.eachNode(excelXML,"/Workbook/Worksheet") do
		local wsTable = {};
		if(WorksheetNode.attr and WorksheetNode.attr["ss:Name"]) then
			--wsTable.name = WorksheetNode.attr["ss:Name"];

			local rowNode;
			local rowIndex = 1;
			--local rowTable = {};

			for rowNode in commonlib.XPath.eachNode(WorksheetNode,"/Table/Row") do
				local rowTable = {};
				if(rowNode.attr and rowNode.attr["ss:Index"]) then
					rowIndex = tonumber(rowNode.attr["ss:Index"]);
				end

				local cellNode;
				local cellIndex = 1;
				--local cellTable = {};

				for cellNode in commonlib.XPath.eachNode(rowNode,"/Cell") do
					local cellTable = {};
					if(cellNode.attr and cellNode.attr["ss:Index"]) then
						cellIndex = tonumber(cellNode.attr["ss:Index"]);
					end	
					
					if(cellNode[1] and cellNode[1][1]) then
						cellTable = {cellNode[1][1],index = cellIndex};
						
						if(cellNode.attr and cellNode.attr["ss:MergeDown"]) then
							cellTable.mergedown = tonumber(cellNode.attr["ss:MergeDown"]);
						end
	
						if(cellNode.attr and cellNode.attr["ss:MergeAcross"]) then
							cellTable.mergeacross = tonumber(cellNode.attr["ss:MergeAcross"]);
						end

						table.insert(rowTable,cellTable);
					end

					cellIndex = cellIndex + 1;
				end
				if(next(rowTable)) then
					--rowTable = {rowTable,index = rowIndex};
					rowTable.index = rowIndex;
					table.insert(wsTable,rowTable);
				end

				rowIndex = rowIndex + 1;
			end
			if(next(wsTable)) then
				wsTable.name = WorksheetNode.attr["ss:Name"];
				table.insert(excelTable,wsTable);
			end
		end
		--if(wsTable[1]) then
			--table.insert(excelTable,wsTable);
		--end
	end
	--echo(excelTable);
	if(next(excelTable)) then
		return excelTable;
	else
		return;
	end
end


function DataBaseChecker.reviewGSIDInExcel(excelTable)
	local res = "";
	local wsheetTable;
	for _,wsheetTable in ipairs(excelTable) do
		if(wsheetTable.name and wsheetTable.name == "GSID") then
			local titleTable;
			local rowTable;
			for _,rowTable in ipairs(wsheetTable) do
				if(rowTable.index and rowTable.index == 10) then
					titleTable = rowTable[1];
				end
				if(rowTable.index and rowTable.index >= 10) then
					
					local fromID,toID;

					if(rowTable[1] and rowTable[1][1] and rowTable[1]["index"] == 1) then
						local gsidregion = rowTable[1][1];
						if(tonumber(gsidregion)) then
							fromID = tonumber(gsidregion);
							toID = tonumber(gsidregion);
						else
							_,_,fromID,toID = string.find(gsidregion,"(%d+)-(%d+)");
						end
					end

					--for _,cellTable in iparis(rowTable) do
						--if(cellTable.index == 1) then
							--if(cellTable[1]) then
								--if(tonumber(cellTable[1])) then
									--fromID = tonumber(cellTable[1]);
									--toID = tonumber(cellTable[1]);
								--else
									--_,_,fromID,toID = string.find(rowTable["gsid"],"(%d+)-(%d+)");
								--end
							--end
						--end
					--end
					local gsid;
					for gsid = fromID,toID do
						local gsidCheckRes = "";
						local index,cellTable;
						for index,cellTable in iparis(rowTable) do
							local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(gsid);
							if(cellTable.index >= 2) then
								if(cellTable[1]) then
									local item;
									if(DataBaseChecker.GlobalStoreCheck.baseItem[titleTable[index][1]]) then
										item = tostring(gsItem[titleTable[index][1]]);	
									elseif(DataBaseChecker.GlobalStoreCheck.templateItem[titleTable[index][1]]) then
										
									end

									local baseItem,templateItem

									local item = tostring(gsItem.template.class);	
									if(class ~= cellTable[1]) then
										gsidCheckRes = gsidCheckRes.."物品"..titleTable[index][1].."属性为:"..gsItem.template[checkItem].."和excel所填值:"..cellTable[1].."不符\n";
									end
								end
							end
						end
					end
				end
			end
		end
	end




	local res = "";
	local rowsTable = excelTable.rowsTable;
	local excelColumn = excelTable.excelColumn;
	local rowTable;
	for _, rowTable in pairs(rowsTable) do
		local _,fromID,toID,class,subclass;
		fromID = nil;
		toID = nil;
		class = nil;
		subclass = nil;
		if(rowTable["gsid"] ~= "") then
			if(string.find(rowTable["gsid"],"-")) then
				_,_,fromID,toID = string.find(rowTable["gsid"],"(%d+)-(%d+)");
			else
				fromID = rowTable["gsid"]; 
				toID = rowTable["gsid"];
			end
		else
			class = rowTable["class"];
			subclass = rowTable["subclass"];
		end
		if(fromID ~= nil) then
			for gsid = fromID,toID do
				local gsidCheckRes = "";
				local checkItem, functionName;
				local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(gsid);
				if(gsItem ~= nil) then
					checkClass(gsItem.template.class,gsItem);

					for checkItem, functionName in pairs(DataBaseChecker.GlobalStoreCheck.templateItem) do
						gsidCheckRes = gsidCheckRes..functionName(gsItem.template[checkItem],gsItem);
						if(checkItem == "stats") then
							local statsCheckRes = DataBaseChecker.checkStats(rowTable.stats,gsItem.template.stats)
							gsidCheckRes = gsidCheckRes..statsCheckRes;
						else
							if(rowTable[checkItem] ~= nil and rowTable[checkItem] ~= "") then
								if(tostring(gsItem.template[checkItem]) ~= tostring(rowTable[checkItem])) then
									gsidCheckRes = gsidCheckRes.."物品"..checkItem.."属性为:"..gsItem.template[checkItem].."和excel所填值:"..rowTable[checkItem].."不符\n";
								end
							end
						end
					end

					for checkItem, functionName in pairs(DataBaseChecker.GlobalStoreCheck.baseItem) do
						gsidCheckRes = gsidCheckRes..functionName(gsItem[checkItem],gsItem);
						if(rowTable[checkItem] ~= nil and rowTable[checkItem] ~= "") then
							if(tostring(gsItem[checkItem]) ~= tostring(rowTable[checkItem])) then
								gsidCheckRes = gsidCheckRes.."物品"..checkItem.."属性为:"..gsItem[checkItem].."和excel所填值:"..rowTable[checkItem].."不符\n";
							end
						end
					end
				else
					gsidCheckRes = gsidCheckRes.."该GSID在数据库中不存在\n";
					break;
				end
				if(gsidCheckRes ~= "") then
					gsidCheckRes = gsid.."检查有误，错误如下：\n"..gsidCheckRes.."\n\n";
				end
				res = res..gsidCheckRes;
					
			end
		end
	end
	return res;


end