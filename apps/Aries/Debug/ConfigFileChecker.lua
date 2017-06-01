--[[
Title:check the config files in AB,which most of are XML document.
]]

NPL.load("(gl)script/apps/Aries/Combat/main.lua");
NPL.load("script/apps/Aries/Debug/DataBaseChecker.lua");

local Combat = commonlib.gettable("MyCompany.Aries.Combat");
local DBChecker = commonlib.gettable("MyCompany.Aries.Debug.Checker.DataBaseChecker");

local ConfigFileChecker = commonlib.gettable("MyCompany.Aries.Debug.Checker.ConfigFileChecker");

local dirTable = ParaXML.LuaXML_ParseFile("config/Aries/Check/directoryPath.xml");



local spellTable = {};
local helpFiles = {};
local helpTable = {};
local checkedFileNumber;

local otherRes = {
	["boss_idRes"] = {}, 
	};
local dataRecord = {
	["boss_id"] = {},
	["curFilePath"] = "",
	["cardDB"] = {};
	};
local redundanceFile = {
	["card"] = {},
	}


function ConfigFileChecker.CheckFiles()

	log(commonlib.Encoding.Utf8ToDefault("begin the checkfile\n"));
	local result = "";

	ConfigFileChecker.Init_SpellTable();
	-- 根据游戏版本决定AB上要检查的文件
	local dirXPath,fileXPath;
	if(System.options.version == "kids") then
		dirXPath = "/dirs/kids/dir";
		fileXPath = "/dirs/kids/filepath";
	else
		dirXPath = "/dirs/teen/dir";
		fileXPath = "/dirs/teen/filepath";
	end

	local rootDir = "config/Aries/";
	local curCheckTyep = "";
	local dirNode;
	for dirNode in commonlib.XPath.eachNode(dirTable,dirXPath) do
		curCheckTyep = dirNode.attr.type;

		helpFiles = {};
		helpTable = {};
		local i = 1;
		
		while (dirNode[i]) do
			helpFiles[dirNode[i].attr.key] = ParaXML.LuaXML_ParseFile(dirNode[i].attr.src);
			i = i + 1;
		end
				
		local isAllRight = true;
		local subDirectory = dirNode.attr.pathValue;
		local completeDirectory = rootDir..subDirectory;
		local AllFiles = {};
		--log(subDirectory.."\n");
		-- 遍历目录下所有文件并将文件名添加到"AllFiles"中
		--if(subDirectory == "Cards/" or subDirectory == "WorldData/") then
		if(subDirectory == "Cards/") then
			commonlib.Files.SearchFiles(AllFiles,completeDirectory,"*.xml",0,10000,true);
		elseif(subDirectory == "Cards/Teen/") then
			commonlib.Files.SearchFiles(AllFiles,completeDirectory,"*.xml",25,10000,true);
		elseif(subDirectory == "WorldData/") then
			commonlib.Files.SearchFiles(AllFiles,completeDirectory,"*.Arenas_Mobs.xml",0,10000,true);
			--echo(AllFiles);
		else
			commonlib.Files.SearchFiles(AllFiles,completeDirectory,"*.xml",25,10000,true);
		end
		dataRecord.cardDB = DBChecker.DataRecord.globalstore.card;

		checkedFileNumber = 1;
		i = 1;
		local _,relativeFilePath,absoluteFilePath;
		local schemaFilePath = "config/Aries/Check/"..dirNode.attr.checkingFileName;
		result = result..completeDirectory.."检查结果如下:\n\n";
		if(curCheckTyep == "Card") then
			for _,relativeFilePath in pairs(AllFiles) do
				local _,_,cardKey = string.find(relativeFilePath,"(.*).xml");
				if(dataRecord.cardDB[cardKey] == nil) then
					table.insert(redundanceFile.card,relativeFilePath);
				else
					absoluteFilePath = rootDir..subDirectory..relativeFilePath;
					local fileResult = ConfigFileChecker.CheckFile(absoluteFilePath,schemaFilePath);
					if(fileResult ~= "") then
						result = result..fileResult.."\n";
						isAllRight = false;
					end
				end
				i = i + 1;
			end

			local redundanceRes = curCheckTyep.."冗余文件包含以下文件:\n";
			local path;
			for _,path in ipairs(redundanceFile.card) do
				redundanceRes = redundanceRes..path.."\n";
			end
			redundanceRes = string.gsub(redundanceRes,"\n","\r\n");
			local resultFile = ParaIO.open("config/Aries/Check/redundanceFile.txt","w");
			if(resultFile:IsValid() ~= true) then
				log("error: failed loading redundanceFile.txt file\n");
				return;
			end
			resultFile:WriteString(redundanceRes);
			resultFile:close();
		else
			for _,relativeFilePath in pairs(AllFiles) do
				absoluteFilePath = rootDir..subDirectory..relativeFilePath;
				local fileResult = ConfigFileChecker.CheckFile(absoluteFilePath,schemaFilePath);
				if(fileResult ~= "") then
					result = result..fileResult.."\n";
					isAllRight = false;
				end

				i = i + 1;
			end
		end
		echo("===========================");
		--echo(schemaFilePath);
		echo("files number is:"..i..";files number which are checked is:"..checkedFileNumber);
		if(isAllRight) then
			result = result.."检查无误\n\n";
		end
	end

	local fileNode;
	for fileNode in commonlib.XPath.eachNode(dirTable,fileXPath) do
		
		curCheckTyep = fileNode.attr.type;

		helpFiles = {};
		helpTable = {};


		local i = 1;
		while (fileNode[i]) do
			helpFiles ={
				[fileNode[i].attr.key] = ParaXML.LuaXML_ParseFile(fileNode[i].attr.src),
			};
			i = i + 1;
		end

		local isRight = true;
		local relativeFilePath = fileNode.attr.pathValue;
		local absoluteFilePath = rootDir..relativeFilePath;

		local schemaFilePath = "config/Aries/Check/"..fileNode.attr.checkingFileName;
		result = result..absoluteFilePath.."检查结果如下:\n\n";
		local fileResult = ConfigFileChecker.CheckFile(absoluteFilePath,schemaFilePath);
		if(fileResult ~= "") then
			result = result..fileResult.."\n";
			isRight = false;
		end
		if(isRight) then
			result = result.."检查无误\n\n";
		end

		echo("===========================");
		--echo(schemaFilePath);
		echo("files number is:1;files number which are checked is:1");
		
	end

	--echo(otherRes["boss_idRes"]);
	if(next(otherRes["boss_idRes"]) ~= nil) then
		local res = "";
		local i = 1;
		local key, value;
		for key, value in pairs(otherRes["boss_idRes"]) do
			res = res.."boss_id:"..key.."在以下文件中重复:\n"..value.."\n";						
		end

		if(res == "") then
			res = "boos_id检查结果如下:\n".."boss_id检查无误."
		else
			res = "boos_id检查结果如下:\n"..res;
		end	
		result = result..res;
	end
	log(commonlib.Encoding.Utf8ToDefault("end the checkfile\n"));
	--echo(otherRes);
	return result;
end

function ConfigFileChecker.checkExcel()
	
end

-- parm:subDirectory    used when check a count of files in folder(for example:"Cards","Cards/Teen"),if check one file,set it:"";
-- parm:subDirectory    the file path for the "config/Aries/" and subDirectory(for example:"CardList.xml"(the subDirectory is "Cards"),"Cards/CardList.xml"(the subDirectory is ""));
-- parm:schemaFile     the path of the file which is used to check the files provided by the parm  "subDirectory" and "subDirFilePath";
-- 检查单个文件
function ConfigFileChecker.CheckFile(filePath,schemaFile)
	local checked = false;
	dataRecord["curFilePath"] = filePath;
	--log(subDirectory.."  "..subDirFilePath.."\n");
	local result = "";
	local leafNodeStyle;
	helpFiles.self = ParaXML.LuaXML_ParseFile(filePath);

	local objectFileXMLTable = ParaXML.LuaXML_ParseFile(filePath);
	local schemaFileXML = ParaXML.LuaXML_ParseFile(schemaFile);
	local isQualified = false;

	local indispensableNodeXPath = commonlib.XPath.selectNode(schemaFileXML,"/checkList/indispensablenode/nodepath/@pathInfile");
	if(indispensableNodeXPath and next(commonlib.XPath.selectNodes(objectFileXMLTable,indispensableNodeXPath))) then
		isQualified = true;
	end
	if(not indispensableNodeXPath) then
		isQualified = true;
	end
	if(isQualified) then
		for leafNodeStyle in commonlib.XPath.eachNode(schemaFileXML,"/checkList/leafnodes/leafnode") do
			local attrTB = leafNodeStyle.attr;
		
			-- initial helpTable;
			if(attrTB.src ~= nil) then
				if(helpTable[attrTB.src] == nil) then
					helpTable[attrTB.src] = {};
				end
				if(attrTB.src == "self") then
					helpTable[attrTB.src][attrTB.pathInSrc] = commonlib.XPath.selectNodes(objectFileXMLTable,attrTB.pathInSrc);
				elseif(helpTable[attrTB.src][attrTB.pathInSrc] == nil) then
					helpTable[attrTB.src][attrTB.pathInSrc] = commonlib.XPath.selectNodes(helpFiles[attrTB.src],attrTB.pathInSrc);
				end	
			
			end
			
			local nodeXPath = attrTB.pathInfile;
			local objectNodeString;
			local isExisting = false;
			-- the value "i" save the amount of nodeXPath in objectFileXMLTable;
			local i = 0;
			local checkResult = "";
			for objectNodeString in commonlib.XPath.eachNode(objectFileXMLTable,nodeXPath) do
				if(not checked) then
					checked = true;
				end
				isExisting = true;
				i = i + 1;
				local curItemCheckResult = "";
				if(objectNodeString ~= "") then
					curItemCheckResult = ConfigFileChecker.valueTypeCheck[attrTB.valueType](objectNodeString,leafNodeStyle);
					if(curItemCheckResult ~= "") then
						local bPosition,ePosition,attrName = string.find(attrTB.pathInfile,"[^@]+@(.*)");		
						curItemCheckResult = "第"..i.."条出错:"..curItemCheckResult..",出错配置为:"..attrName.."="..objectNodeString.."\n";
					end
				else
					if(objectNodeString == "") then
						if(not attrTB.canEmpty) then
							curItemCheckResult = "第"..i.."条出错:该项值不能配置为空\n";
						end	
					else
						log("error:the file structure is wrong:"..filePath.."\n");	
					end
				end
				checkResult = checkResult..curItemCheckResult;
			end

			if((not isExisting) and (attrTB.mustBe == "true" or attrTB.mustbe == "true")) then
				checkResult = ":该项内容为必须配置，不能略去\n";
			end
			if(checkResult ~= "") then
				checkResult = nodeXPath.."\n"..checkResult.."\n";
			end
			result = result..checkResult;
		end
		if(result ~= "") then
			result = filePath.."\n"..result;
		end
		if(checked) then
			checkedFileNumber = checkedFileNumber + 1;
		end
	end
	dataRecord["curFilePath"] = "";
	return result;
	
end

-- judge number is in numberArea
local function isArea(number,areaString)
	local num;
	if(type(number) == "string") then
		num = tonumber(number);
	else
		num = number;
	end
	if(num == nil or type(num) ~= "number") then
		return nil;
	--	log("error:function isArea");
	end
	if((not areaString) and areaString == "") then
		return nil;
	--	log("error:function isArea");
	end
	local isDesirable = false;
	local lower,higher;

	local areaItem;
	areaItem = string.gsub(areaString,"%s+","");
	--log(num.."    "..areaString);
	--log("\n");
	areaItem = string.gsub(areaItem,"u","U");
	for lower,higher in string.gfind(areaItem,"(%-?%w+%.?%d*),?(%-?%w*%.?%d*)") do     
		-- judge whether the higher is existing      
		if(higher == "U" or tonumber(higher)) then	
			local str = lower..","..higher;
			local isDesirableLeft = false;
			local isDesirableRight = false;

			areaItem = string.gsub(areaItem,str,"");

			local lBracket = string.sub(areaItem,1,1);
			local rBracket = string.sub(areaItem,2,2);
			--log(lBracket..rBracket.."\n");
			if(lower ~= "U") then
				if(lBracket == "[") then
					if(num >= tonumber(lower)) then
						isDesirableLeft = true;
					--	log("左边中括号满足要求\n");
					end
				else
					if(num > tonumber(lower)) then
						isDesirableLeft = true;
					--	log("左边圆括号满足要求\n");
					end
				end
			else
				isDesirableLeft = true;
			end
			if(higher ~= "U") then
				if(rBracket == "]") then
					if(num <= tonumber(higher)) then
						isDesirableRight = true;
					--	log("右边中括号满足要求\n");
					end
				else
					--_guihelper.MessageBox(tonumber(higher));
					if(num < tonumber(higher)) then
						isDesirableRight = true;
					--	log("右边圆括号满足要求\n");
					end
				end
			else
				isDesirableRight = true;
				--log("右边中括号满足要求\n");
			end
			if(isDesirableLeft and isDesirableRight) then
				isDesirable = true;
				break;
			end

			if(string.len(areaItem) > 2) then
				areaItem = string.sub(areaItem,3);
				--log("再次了\n");
			end
		else
			local str = lower;
			areaItem = string.gsub(areaItem,lower,"");

			if(num == tonumber(lower)) then
				isDesirable = true;
				break;
			end

			if(string.len(areaItem) > 2) then
				areaItem = string.sub(areaItem,3);
				--log("再次了\n");
			end
		end
	end  -- the "end" symbol for the nearest "for" symbol
	return isDesirable;
end

local function judgeLootListWithOdds(lootString)

	local result = "";
	local captureGSID;
	local captureNumber;

	local captureOdds;
	local oddsSumRes;
	local oddsSum = 0;
	if string.find(lootString,"^{(.*)}$") then
		for captureGSID,captureNumber,captureOdds in string.gfind(lootString,"%[(%d+),(%d+)%]=(%d+%.*%d*)") do
			local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(tonumber(captureGSID));
			local res = "";
			if(gsItem) then
				if(gsItem.template.maxcount == 1 and tonumber(captureNumber) ~= 1) then
					res = res..",".."唯一性物品，但是掉落数量大于1";
				end
			else
				res = res..",".."该物品不存在";
			end
			if(tonumber(captureOdds) <= 0 or tonumber(captureOdds) >100) then
				res = res..",".."物品掉落几率不能大于100或者小于0";
				--res = res..",".."掉落几率配置出界";
			end
			if(oddsSum <= 100) then
				oddsSum = oddsSum + tonumber(captureOdds);
				if(oddsSum > 100) then
					oddsSumRes = "掉落几率总和不能大于100";
				end
			end
			if(res ~= "") then
				res = "  "..captureGSID..res;
				result = result..res;
			end
		end
		if(oddsSumRes) then
			result = "  "..oddsSumRes..result;
			--log(result.."\n");
		end
	else
		result = "loot格式书写有误";
	end
	

	return result;
end

local function judgeLoot(lootString)
	local result = "";
	local captureGSID;
	local captureNumber;
	--log(elementValue..attrCheck.attr.patternTemplate)
	for captureGSID,captureNumber in string.gfind(lootString,"%((%d+),(%d+)%)") do
		local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(tonumber(captureGSID));
		local res = "";
		if(gsItem) then
			if(gsItem.template.maxcount == 1 and tonumber(captureNumber) ~= 1) then
				res = res..",".."唯一性物品，但是掉落数量大于1";
			end
		else
			res = res..",".."该物品不存在";
		end

		if(res ~= "") then
			res = "  "..captureGSID..res;
			result = result..res;
		end
	end

	return result;
end

local function judgeCardString(cardString)
	local result = "";
	local cardGSID;
	local cardNumber;
	local haCost0PipCard = false;

	local statTable = {
		stat_type = {
			"stat_type_1","stat_type_2","stat_type_3","stat_type_4","stat_type_5","stat_type_6","stat_type_7","stat_type_8","stat_type_9","stat_type_10",
		},
		stat_value = {
			"stat_value_1","stat_value_2","stat_value_3","stat_value_4","stat_value_5","stat_value_6","stat_value_7","stat_value_8","stat_value_9","stat_value_10",
		},
	};
	for cardGSID,cardNumber in string.gfind(cardString,"%((%d+),(%d+)%)") do
		local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(tonumber(cardGSID));
		local res = "";
		if(gsItem) then
			if(gsItem.template.class ~= 18) then
				res = res..",".."该GSID的class不是卡牌";
			end
			if(haCost0PipCard == false) then
				local i,stat_typeItem,stat_valueItem;
				for i,stat_typeItem in pairs(statTable.stat_type) do
					stat_valueItem = statTable.stat_value[i];
					if(gsItem.template[stat_typeItem] == "134" and gsItem.template[stat_valueItem] == "0") then
						haCost0PipCard = true;
						break;
					end
				end
			end
		else
			res = res..",".."该GSID在数据库中不存在";
		end

		if(tonumber(cardNumber) <= 0) then
			res = res..",".."卡牌数目不能小于0";
		end
		if(res ~= "") then
			res = "  "..cardGSID..res;
			result = result..res;
		end
	end

	--if(haCost0PipCard == false) then 
		--result = "该出牌配置中没有配置魔力点消耗为0的卡牌;"..result;
	--end
	return result;

end

local function checkEnumString(checkedString,checkTable)
	local result = "";
	local isDesirable = false;
	local enumItem;
	for enumItem in string.gmatch(checkTable.attr.stringCollection,"([^,]+),?") do
		if(checkedString == enumItem) then
			isDesirable = true;
			break;
		end
	end
	if(not isDesirable) then
		result = "配置内容不是枚举字符串中任何一项";
	end
	return result;
end

local function checkNumber(checkedString,checkTable)
	local nodePath = checkTable.attr.pathInfile;
	local result = "";
	local checkedNumber = tonumber(checkedString);
	if(checkedNumber) then
		if(checkTable.attr.numberArea) then
			local isDesirable = isArea(checkedNumber,checkTable.attr.numberArea);
			if(isDesirable == nil) then
				log("error:function isArea||checkedString="..checkedString..",nodePath="..nodePath.."\n");
			end
			if(not isDesirable) then
				result = "数值不在指定区间内";
			end
		end
	else
		result = "该项内容必须为一个数值";
	end
	return result;
end

local function checkNumberList(checkedString,checkTable)
	local result = "";
	local eachNumber;
	local i=1;
	for eachNumber in string.gfind(checkedString,"(%d+)") do
		
		local eachNumberCheckResult = "";
		eachNumberCheckResult =  checkNumber(eachNumber,checkTable);
		if(eachNumberCheckResult ~= "") then
			eachNumberCheckResult = "第"..i.."个值'"..eachNumber.."'出错："..eachNumberCheckResult;
			result = result..eachNumberCheckResult;
		end
	end

	if(result ~= "") then
		result = "序列检查结果：\n"..result;
	end

	return result;
end

local function checkModifyStatList(checkedString,checkTable)
	log(checkTable.attr.statArea.."  "..checkTable.attr.modifyValueArea.."\n");
	local result = "";
	local stat,modifyValue;
	local cellRes;
	local checkTable_stat = {
		attr={
			pathInfile = checkTable.attr.pathInfile,
			valueType = checkTable.attr.valueType,
			numberArea = checkTable.attr.statArea,
		},
	};
	local checkTable_modifyValue = {
		attr={
			pathInfile = checkTable.attr.pathInfile,
			valueType = checkTable.attr.valueType,
			numberArea = checkTable.attr.modifyValueArea,
		},
	};
	for stat,modifyValue in string.gfind(checkedString,"(%-?%w+%.?%d*),(%-?%w+%.?%d*)") do   
		cellRes = "";
		local statRes = checkNumber(tonumber(stat),checkTable_stat);
		if(statRes ~= "") then
			--log(statRes.."  "..stat.."  "..checkTable_stat.attr.numberArea.."\n");
			cellRes = "stat值"..stat.."不是正确的状态值;";
		end

		local modifyValueRes = checkNumber(tonumber(modifyValue),checkTable_modifyValue);
		if(modifyValueRes ~= "") then
			--log(modifyValueRes.."  "..modifyValue.."  "..checkTable_modifyValue.attr.numberArea.."\n");
			cellRes = "对属性值"..stat.."的修改"..modifyValue.."超出规定范围;";
		end
		result = result..cellRes;
	end
	return result;
end

local function checkLootWithOdds(checkedString,checkTable)
	local result = "";
	if(checkedString ~= "{}") then
		--log(checkedString.."\n");
		result = judgeLoot(checkedString);
	end
	return result;
end

local function checkLootWithGiftBag(checkedString,checkTable)
	local result = "";
	local _,giftBagGSID,loot;
	_,_,giftBagGSID,loot = string.find(checkedString,"(%d+)%+(.*)");
	local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(tonumber(giftBagGSID));
	if(not gsItem) then
		result = "该掉落中配置的礼包的GSID不存在;";
	end
	result = result..judgeLoot(loot);
	return result;
end

local function checkNumberRange(checkedString,checkTable)
	local nodePath = checkTable.attr.pathInfile;
	local result = "";

	local _,numberRangeLower,numberRangeHigher;
	--leafNodeValue = string.gsub(ccheckedString,"%s","");
	_,_,numberRangeLower,numberRangeHigher = string.find(checkedString,"(%-*%d*%.*%d*%s?),(%-*%d*%.*%d*%s?)");
	numberRangeLower = tonumber(numberRangeLower);
	numberRangeHigher = tonumber(numberRangeHigher);

	local isFloorDesirable = isArea(numberRangeLower,checkTable.attr.numberRangeFloor);
	if(isFloorDesirable == nil) then
		log("error:function isArea||checkedString="..checkedString..",nodePath="..nodePath.."\n");
	end

	local isUpperDesirable = isArea(numberRangeHigher,checkTable.attr.numberRangeUpper);
	if(isUpperDesirable == nil) then
		log("error:function isArea||checkedString="..checkedString..",nodePath="..nodePath.."\n");
	end


	local isHigherMoreThanLower = false;
	if(numberRangeLower < numberRangeHigher) then
		isHigherMoreThanLower = true;
	else
		result =result.."下限值大于上限值;";
	end

	if(not isFloorDesirable) then
		result = result.."下限值不在规定区间;";
	end

	if(not isUpperDesirable) then
		result = result.."上限值不在规定区间;";
	end

	return result;
end

local function checkCardList(checkedString,checkTable)
	local result = "";
	local result = judgeCardString(checkedString);
	return result;
end

local function checkAssetPath(checkedString,checkTable)
	local result = "";
	if( not ParaIO.DoesFileExist(checkedString)) then
		result = "文件路径不存在";
	end
	return result;
end

local function checkCardName(checkedString,checkTable)
	local result = "";
	local cardGSID;
	if(tonumber(checkedString)) then
		cardGSID = tonumber(checkedString);
	else
		if(dataRecord.cardDB[checkedString] == nil) then
			result = result..",".."该卡牌在数据库中不存在"; 
		else
			cardGSID = dataRecord.cardDB[checkedString].gsid;
		end
	end
	return result;
end

local function checkMobSequenceRoundNum(checkedString,checkTable)
	local result;
	local roundNumber = string.gsub(checkedString,"[+-]","");
	result = checkNumber(roundNumber,checkTable);
	return result;
end

local function checkCardGSID(checkedString,checkTable)
	local result = "";
	local cardGSID = tonumber(checkedString);
	if(cardGSID) then
		local gsItem = System.Item.ItemManager.GetGlobalStoreItemInMemory(cardGSID);
		if(gsItem.template.class ~= 18) then
			result = result..",".."该配置的class不是卡牌类型";
		end
	else
		result = result..",".."该卡牌在84数据库中不存在";
	end

	return result;
end

local function checkCardKeyName(checkedString,checkTable)
	local cardGSID = Combat.Get_gsid_from_cardkey(checkedString) or Combat.Get_gsid_from_rune_cardkey(checkedString);
	return checkCardGSID(cardGSID,checkTable);
end

local function checkCardSpellName(checkedString,checkTable)
	local result = "";
	if(not spellTable[checkedString]) then
		result = "Spells目录下找不到卡牌对应spell;";
	end
	--echo(result);
	return result;
end

local function checknumWithCharList(checkedString,checkTable)
	local numList = string.gsub(checkedString,"%a","");
	return checkNumberList(numList,checkTable);
end

local function checknumWithChar(checkedString,checkTable)
	local nodePath = checkTable.attr.pathInfile;
	local result = "";
	local num = string.gsub(checkedString,"%a","");
	num = tonumber(num);
	local isDesirable = isArea(num,checkTable.attr.numberArea);
	if(isDesirable == nil) then
		log("error:function isArea||checkedString="..checkedString..",nodePath="..nodePath.."\n");
	end
	if(isDesirable == false) then
		result = "该数值不在规定区间内";
	end
	return result;
end

local function checkFilePath(checkedString,checkTable)
	local result = "";
	if( not ParaIO.DoesFileExist(checkedString)) then
		result = "文件路径不存在";
	end
	return result;
end

local function checkLoot(checkedString,checkTable)
	return judgeLoot(checkedString);
end

local function checkLobbyLoots(checkedString,checkTable)
	local loot = string.gsub(checkedString,"|",")(");
	loot = "("..loot..")";
	return checkLoot(loot);
end

local function checkComplexCardType(checkedString,checkTable)
	local result = "";
	local isDesirable = false;
	local cardTypeId = tonumber(checkedString);

	local xmlTable = helpTable[checkTable.attr.src][checkTable.attr.pathInSrc];
	local _,id;
	for _,id in ipairs(xmlTable) do
		if(cardTypeId == tonumber(id)) then
			isDesirable = true;
			break;
		end
	end
	if(isDesirable == false) then
		result="在文件"..checkTable.attr.src.."里没要找到对应配置的id;";
	end
	return result;
end

local function check_number_In_cardsets(checkedString,checkTable)
	local result = "";
	local isDesirable = false;
	local xmlTable = helpTable[checkTable.attr.src][checkTable.attr.pathInSrc];
	local _, setIDItem;
	for _, setIDItem in ipairs(xmlTable) do
		if(tonumber(checkedString) == tonumber(setIDItem)) then
			isDesirable = true;
			break;
		end
	end
	if(isDesirable == false) then
		result = "在该文件自身的"..checkTable.attr.pathInSrc.."路径下没有找到对应cardset";
	end
	return result;
end


local function check_lobbyPlayerNumbers(checkedString,checkTable)
	local result = "";

	return result;
end

local function check_complexType(checkedString,checkTable)

	local function splitString(str,pattern)
		local u, v, w, x, y, z;
		local tb = {};
		for u, v, w, x, y, z in string.gmatch(str,pattern) do
			--echo(u, v, w, x, y, z);
			local cell = {};
			cell[1] = u;
			cell[2] = v;
			cell[3] = w;
			cell[4] = x;
			cell[5] = y;
			cell[6] = z;
			if(next(cell) == nil) then
				echo("wrong");
			end
			table.insert(tb,cell);
		end
		return tb;
	end

	local t = splitString(checkedString,checkTable.attr.pattern);
	local cell, unit;
	local unitNum = checkTable.attr.unitNum;
	local result = "";
	
	local isEmpty = false;
	if(unitNum ~= nil) then
		if(next(t) == nil) then
			result = "配置内容中没有找到匹配项;";
		else
			for _, cell in pairs(t) do
				local unitValue;
				for i = 1,unitNum do
					local unitRes = "";
					local styleAttr = checkTable[i].attr.valueType;
					if(cell[i] == nil) then
						isEmpty = true;
						unitRes = "第".._.."单元".."第"..i.."个值没有配置;"
					else
						unitRes = ConfigFileChecker.valueTypeCheck[styleAttr](cell[i],checkTable[i]);
						if(unitRes ~= "") then
							unitRes = "第".._.."单元".."第"..i.."个值配置有误"..unitRes;
						end
					end
					if(unitRes ~= "") then
						result = result..unitRes;
					end
				end
		
			end
		end
	end
	
	--for leafNodeStyle in commonlib.XPath.eachNode(checkTable,"/checkList/leafnodes/leafnode") do
	----stop
	--end

	result = string.gsub(result,"\n","");
	return result;
end

local function check_pipcost(checkedString,checkTable)
	local result = "";
	result = ConfigFileChecker.valueTypeCheck["number"](checkedString,checkTable);

	local relationResult = "";
	local spell_school = helpTable[checkTable.attr.src][checkTable.attr.pathInSrc][1];
	if(i == "balance" and tonumber(checkedString) > 7) then
		relationResult = "平衡系卡牌消耗魔力点不能大于7！"
	end
	if(relationResult ~= "") then
		result = result..relationResult;
	end

	return result;
end

local function check_boss_id(checkedString,checkTable)
	local result = "";
	if(dataRecord["boss_id"][checkedString] == nil) then
		dataRecord["boss_id"][checkedString] = dataRecord["curFilePath"];
	else
		if(otherRes["boss_idRes"][checkedString] == nil) then
			otherRes["boss_idRes"][checkedString] = "";
			otherRes["boss_idRes"][checkedString] = otherRes["boss_idRes"][checkedString]..dataRecord["boss_id"][checkedString]..", "..dataRecord["curFilePath"]..", ";
		else
			otherRes["boss_idRes"][checkedString] = otherRes["boss_idRes"][checkedString]..dataRecord["curFilePath"]..", ";
		end
	end

	return result;
end

local function empty(checkedString,checkTable)
	local result = "";

	return result;
end

ConfigFileChecker.valueTypeCheck = {

	["number"] = checkNumber,
	["numberList"] = checkNumberList,
--	["numberCellList"] = checkNumberCellList,
	["enumString"] = checkEnumString,
--	["enumStringList"] = checkEnumStringList,
	["lootWithOdds"] = checkLootWithOdds,
	["numberRange"] = checkNumberRange,
	["cardGSID"] = checkCardGSID,
	["cardList"] = checkCardList,
	["cardName"] = checkCardName,
	["assetPath"] = checkAssetPath,
	["mobSequenceRoundNum"] = checkMobSequenceRoundNum,
	["cardKeyName"] = checkCardKeyName,
	["cardSpellName"] = checkCardSpellName,
	["numWithcharList"] = checknumWithCharList,   ---used to check the "card/params/@dots"(for a instance:dots="40p,40p,40p");
	["numWithchar"] = checknumWithChar,           ---used to check the "card/params/@damage_max" and "card/params/@damage_min"(for example:damage_min="85p");
	["filePath"] = checkFilePath,
	["loot"] = checkLoot,
	["lootWithGiftBag"] = checkLootWithGiftBag, 
	["lobbyLoots"] = checkLobbyLoots,
	["modifyStatList"] = checkModifyStatList,
--	["isArea"] = isArea,
	["complexCardType"] = checkComplexCardType,
	["number_In_cardsets"] = check_number_In_cardsets,
	["lobbyPlayerNumbers"] = check_lobbyPlayerNumbers,
	["complexType"] = check_complexType,
	["pipcost"] = check_pipcost,
	["boss_id"] = check_boss_id,
	["string"] = empty,
};



function ConfigFileChecker.Init_SpellTable()
	local spellFolderPath = "config/Aries/Spells/";
	local files = {};
	commonlib.Files.SearchFiles(files,spellFolderPath,"*.xml",25,10000,true);
	local _ ,fileName;
	for _,fileName in pairs(files) do
		_,_,fileName = string.find(fileName,"/?([_%w]*)%.");
		spellTable[fileName] = true;
	end
end

function ConfigFileChecker.judgeSpellFile(spellFileName)
	return spellTable[spellFileName];
end
