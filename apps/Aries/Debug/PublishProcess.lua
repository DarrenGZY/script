
--[[
Title: code behind for page Checker.html
Author(s): WangTian
Date: 2009/4/24
Desc:  script/apps/Aries/Debug/Checker.html
Use Lib:
-------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Debug/PublishProcess.lua");
local Checker = commonlib.gettable("MyCompany.Aries.Debug.Checker");
Checker.main();
-------------------------------------------------------
]]

NPL.load("(gl)script/apps/Aries/Combat/main.lua");
NPL.load("script/apps/Aries/Debug/DataBaseChecker.lua");
local DataBaseChecker = commonlib.gettable("MyCompany.Aries.Debug.Checker.DataBaseChecker");
NPL.load("script/apps/Aries/Debug/ConfigFileChecker.lua");
local ConfigFileChecker = commonlib.gettable("MyCompany.Aries.Debug.Checker.ConfigFileChecker");



--MyCompany.Aries.Debug.Checker = MyCompany.Aries.Debug.Checker or {};
local Checker = commonlib.gettable("MyCompany.Aries.Debug.Checker");


--Checker.OutFile = {};


--function Checker.Init()
	--Checker.Init_SpellTable();
	--local outFileNode;
	--for outFileNode in commonlib.XPath.eachNode(directoryPathTable,"") do
		--
	--end
--end
function Checker.main(isAll)
	log("the begin of check");
	local resultFile = ParaIO.open("config/Aries/Check/allCheckResult.txt","w");
	if(resultFile:IsValid() ~= true) then
		log("error: failed loading resultFile.txt file\n");
		return;
	end

	local result;

	-- 检查84配置
	local checkDBRes;
	if(isAll) then
		checkDBRes = DataBaseChecker.CheckDB();
	else
		checkDBRes = DataBaseChecker.checkExcel();
	end


	--local checkDBRes = if_else(isAll,DataBaseChecker.CheckDB(),DataBaseChecker.checkExcel());
	-- 检查AB配置文件
	local checkFileRes = ConfigFileChecker.CheckFiles();
	
	checkDBRes = "本地数据库检查结果如下:\n"..checkDBRes.."\n";	
	--echo(checkDBRes);
	checkFileRes = "本地配置文件检查结果如下:\n"..checkFileRes.."\n";
	--echo(checkFileRes);
	result = checkFileRes..checkDBRes;
	result = string.gsub(result,"\n","\r\n");
	resultFile:WriteString(result);
	resultFile:close();
	log("the end of check");
	_guihelper.MessageBox("检查完毕,查看检查结果请看文件:config/Aries/Check/allCheckResult.txt");
	--log(commonlib.Encoding.Utf8ToDefault("检查完毕\n"));
end


function Checker.checkExcel()

	local function readExcel()
		local excelTable = {
			excelColumn = {},
			rowsTable = {},
		};
		local excelPath = "config/Aries/Check/GSID_Rule.xml";
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
			if(index == 1) then
				for cellNode in commonlib.XPath.eachNode(rowNode,"/Cell") do
					value = string.lower(cellNode[1][1]);
					excelTable.excelColumn[columnIndex] = value;
					columnIndex = columnIndex + 1;
				end 

			else
				
				local isOver = false;
				local stat_typeValue;
				local rowTable = {
					["stat"] = {},
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
								rowTable["stat"][value] = "";
							elseif(excelTable.excelColumn[columnIndex] == "stat_value") then
								rowTable["stat"][stat_typeValue] = value;
							end
						else
							rowTable[excelTable.excelColumn[columnIndex]] = value;
						end
						columnIndex = columnIndex + 1;
					end
				
				end
				if(next(rowTable["stat"]) == nil) then
					rowTable["stat"] = nil;
				end
				if(next(rowTable) ~= nil) then
					excelTable.rowsTable[index] = rowTable;
				end
			end
			index = index + 1;
		end
		return excelTable;
	end

	local function reviewExcelTable(excelTable)
		local statTable = {
			stat_type = {
				"stat_type_1","stat_type_2","stat_type_3","stat_type_4","stat_type_5","stat_type_6","stat_type_7","stat_type_8","stat_type_9","stat_type_10",
			},
			stat_value = {
				"stat_value_1","stat_value_2","stat_value_3","stat_value_4","stat_value_5","stat_value_6","stat_value_7","stat_value_8","stat_value_9","stat_value_10",
			},
		};
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

						for checkItem, functionName in pairs(Checker.GlobalStoreCheck.templateItem) do
							gsidCheckRes = gsidCheckRes..functionName(gsItem.template[checkItem],gsItem);
							if(checkItem == "stat") then
								if(next(rowTable["stat"]) ~= nil) then
									for i = 1,10 do
										local stat_typeValue = tostring(gsItem.template[statTable.stat_type[i]]);
										if(stat_typeValue ~= "0") then
											if(rowTable["stat"][stat_typeValue] ~= nil) then
												if(rowTable["stat"][stat_typeValue] ~= "") then
													if(tostring(gsItem.template[statTable.stat_value[i]]) == rowTable["stat"][stat_typeValue]) then
														rowTable["stat"][stat_typeValue] = nil;
													else
														rowTable["stat"][stat_typeValue] = "0";
													end
												else
													rowTable["stat"][stat_typeValue] = nil;
												end
											end
										end
									end
								end
							else
								if(rowTable[checkItem] ~= nil and rowTable[checkItem] ~= "") then
									if(tostring(gsItem.template[checkItem]) ~= tostring(rowTable[checkItem])) then
										gsidCheckRes = gsidCheckRes.."物品"..checkItem.."属性为:"..gsItem.template[checkItem].."和excel所填值:"..rowTable[checkItem].."不符\n";
									end
								end
							end
						end

						for checkItem, functionName in pairs(Checker.GlobalStoreCheck.baseItem) do
							gsidCheckRes = gsidCheckRes..functionName(gsItem[checkItem],gsItem);
							if(rowTable[checkItem] ~= nil and rowTable[checkItem] ~= "") then
								if(tostring(gsItem[checkItem]) ~= tostring(rowTable[checkItem])) then
									gsidCheckRes = gsidCheckRes.."物品"..checkItem.."属性为:"..gsItem[checkItem].."和excel所填值:"..rowTable[checkItem].."不符\n";
								end
							end
						end

						if(next(rowTable["stat"]) ~= nil) then
							local type, value;
							for type, value in pairs(rowTable["stat"]) do
								if(value == "") then
									gsidCheckRes = gsidCheckRes.."该GSID中没有配置".."stat_type:"..type;			
								elseif(value == "0") then
									gsidCheckRes = gsidCheckRes.."该GSID中".."stat_type:"..type.."的stat_value和excel填写的不相等";
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

	local table = readExcel();
	local res = reviewExcelTable(table);

	res = string.gsub(res,"\n","\r\n");
	local resultFile = ParaIO.open("config/Aries/Check/excelCheckResult.txt","w");
	if(resultFile:IsValid() ~= true) then
		log("error: failed loading redundanceFile.txt file\n");
		return;
	end
	resultFile:WriteString(res);
	resultFile:close();
	_guihelper.MessageBox("检查完成,检查结果请查看文件:config/Aries/Check/excelCheckResult.txt");
end


function Checker.test()
--~ 	local checkFileXML = commonlib.XPath.selectNode(testXML,"/configs/subdirectory[@value = 'cards']");
--~ 	checkFileXML = {checkFileXML,n=1};
--~ 	local str = commonlib.XPath.selectNode(checkFileXML,"/subdirectory/checkleafnode");
--~ 	_guihelper.MessageBox(str);
	--local s = {"haha","你们",["他"] = "good",};
	--log(s[1].."   "..s[2].."   "..s["他"].."\n");
	
	local resultFile = io.open("Z:/KidsMovie/ParaEngineSDK/config/Aries/Check/cardList.txt","r");
	--if(resultFile:IsValid() ~= true) then
		--log("error: failed loading resultFile.txt file\n");
		--return;
	--end

	local resultFileRes = io.open("Z:/KidsMovie/ParaEngineSDK/config/Aries/Check/cardListRes.txt","w");
	--if(resultFile:IsValid() ~= true) then
		--log("error: failed loading resultFile.txt file\n");
		--return;
	--end
	local res = "";
	local line;
	local lines = {};
	for line in io.lines("Z:/KidsMovie/ParaEngineSDK/config/Aries/Check/cardList.txt") do
		--log(line.."\n");
		table.insert(lines,line);
	end
	local i,l;
	local card,str,cardlist;
	for i, l in ipairs(lines) do
		log(l.."1111111\n");
		local num = string.sub(l,1,3);
		log(num.."3333333\n");
		local cards = string.sub(l,4);
		cardlist = "";
		log(cards.."2222222\n");
		for card in string.gfind(cards,"([^%+]+)+?") do
			cardlist = cardlist..card;
			--log(card.."\n");
			local gsid = Combat.Get_gsid_from_showName(card);
			if(not gsid) then
				log("gsid is nil");
			end
			log(gsid.."\n");
			local gsid1,gsid2,gsid3,gsid4 = string.match(gsid,"(%d*),?(%d*),?(%d*),?(%d*)");
			local gsItem;
			if(gsid4 ~= "") then
				cardlist = cardlist.."error".."+";
			else
				if(gsid3 ~= "") then
					--cardlist = cardlist.."error".."+";
					if((tonumber(gsid2)-tonumber(gsid1) == 10000) or (tonumber(gsid3)-tonumber(gsid1) == 1000)) then
						cardlist = cardlist..gsid1.."+";
					else
						if(tonumber(gsid3)-tonumber(gsid2) == 10000) then
							cardlist = cardlist..gsid2.."+";
						else
							cardlist = cardlist.."wrong".."+";
						end
					end
				else
					if(gsid2~="") then
							--gsid2 = gsid1;
							----gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(tonumber(gsid2));
							--cardlist = cardlist..gsid2.."+";
						--gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(tonumber(gsid1));
						--cardlist = cardlist..gsid1.."+";
						log(card..gsid.."\n");
					end
					cardlist = cardlist..gsid1.."+";
				end
			end
			--log(commonlib.Encoding.Utf8ToDefault(cardlist).."\n");
			--resultFileRes:write(tostring(cardlist).."\n");
		end
		cardlist = num.."\n"..cardlist;
	
		--resultFileRes:write(tostring(l).."\n");
		resultFileRes:write(cardlist.."\n");
		--log("1111111111111111\n");
	end
	resultFileRes:close();
	resultFile:close();

	_guihelper.MessageBox("转换完毕,结果请看文件:config/Aries/Check/resultFile.txt");
	log(commonlib.Encoding.Utf8ToDefault("转换完毕\n"));
end


function Checker.trans(card) 
local gsid = Combat.Get_gsid_from_showName(card);
_guihelper.MessageBox(gsid);
end

--function Checker.creatNewWindow();
	--System.App.Commands.Call("File.MCMLWindowFrame", {
			--url = "script/apps/Aries/Debug/MoveCard.html", 
			--name = "Checker.creatNewWindow", 
			--app_key=MyCompany.Aries.app.app_key, 
			----app_key=MyCompany.Taurus.app.app_key, 
			--isShowTitleBar = false,
			--DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
			--style = CommonCtrl.WindowFrame.ContainerStyle,
			--zorder = -10,
			--allowDrag = false,
			--click_through = true,
			--directPosition = true,
				--align = "_ct",
				--x = 0,
				--y = 0,
				--width = 100,
				--height = 200,
		--});
--end