--[[
Title: code behind for page MobWikiPage.html
Author(s): WD
Date: 2011/07/05
Desc:  script/apps/Aries/Debug/MobWikiPage.html
Use Lib:
-------------------------------------------------------
-------------------------------------------------------
]]

ARENAMOBS_FILE_PATH = "config/Aries/WorldData/";
ARENAMOBS_FILTER = "*.Arenas_Mobs.xml";
EXPORT_FILE_PATH = "temp/Aries/export/";

local MobWikiPage = commonlib.gettable("MyCompany.Aries.App.MobWikiPage");
NPL.load("(gl)script/ide/common_control.lua");

--[[
	initialize mob wiki page
--]]
function MobWikiPage:Init()
	--assign document page var
	self.page = document:GetPageCtrl();
	--assign table for mobs datasource
	self.MobDataSet = {};
	--assign table for one mob
	self.MobDataTable = {};

	--store mob data file
	self.MobFile= {};
	self.ArenaMobs= {};
	self.MobLoot = {};
	self.MobExported = {};

	self:SearchMobs();
	--call ExtractModsFromXML
	self:ParseMobs();

	self.page:CallMethod("pegvwMobLoot", "SetDataSource", self.MobLoot);
    self.page:CallMethod("pegvwMobLoot", "DataBind");
end

--[[
	enumate all mob from xml file
--]]
function MobWikiPage:SearchMobs()
	local i,j = 0,0;
	local result = ParaIO.SearchFiles(ARENAMOBS_FILE_PATH,ARENAMOBS_FILTER,"",0,50,0);
	local size = result:GetNumOfResult();

	i = table.getn(self.MobFile) + 1;
	for j = 0,size do
		self.MobFile[i] =  result:GetItem(j);
		i = i + 1;
	end

	result:Release();
end

--[[
	extract mob attributes one by one on each arena
	the follow is MobDataTable structure.
	MobDataTable = {
		{
	
			fileName = mobFile,
			profile = {
				mobName = mob display name,
				loot = {
					loot1 = 
					{
						{
							gsid,
							count,
							rate
						},
						...
					},
					loot2 = {},
				}
			}
		}
	}
--]]
function MobWikiPage:ParseMobs()
	local i,size = 0,table.getn(self.MobFile);
	local EnumChildNodeByXPath = commonlib.XPath.eachNode;
	
	for i = 1 ,size do -->for arenas
		local path = ARENAMOBS_FILE_PATH .. self.MobFile[i];
		local arenas = ParaXML.LuaXML_ParseFile(path);
		local _,_,worldName = string.find(path,"(.+)%.Arenas_Mobs.xml$");
		local world = {
			worldName = worldName,
			arena= {}
		};

		self.ArenaMobs[i] = world;
		-- get mob attr
		local arena;
		local k = 1;

		for arena in EnumChildNodeByXPath(arenas,"/arenas/arena") do 
			local mob,arena = nil,{
				id = arena.attr.id,
				position = arena.attr.position,
				templates = {}
			};

			self.ArenaMobs[i].arena = arena;

			for mob in EnumChildNodeByXPath(arenas,"/arenas/arena/mob") do
				local temp = mob.attr.mob_template;
				
				if (temp ~= "" ) then
					arena.templates[k] = temp;
					k = k + 1;
					
					--if not add same mob ,add it
					if(self:ContainTemplate(temp) == false) then
						local mobRoot = ParaXML.LuaXML_ParseFile(temp);
						local mobProfile;
						
						for mobProfile in EnumChildNodeByXPath(mobRoot,"/mobtemplate/mob") do
							
							local tlbMob = {
								fileName = temp,
								profile = 
								{
									--guard_distance,
									mobName = mobProfile.attr.displayname,
									loot = { loot1={},loot2={}}
								}
							};
							
							local loot = nil;
							local lootRaw = "";
							local LOOT_PATTERN = "%b[]%p%d+[%.]?%d+";

							if(mobProfile.attr.loot1 ~= nil) then
								lootRaw = mobProfile.attr.loot1;
								for loot in string.gmatch(lootRaw,LOOT_PATTERN) do
									local child = 
									{
										gsid = string.match(loot,"%[(%d+),");
										count = string.match(loot,",(%d+)%]=");
										rate = string.match(loot,"%d+[%.]?%d+$") .. "%";
									};	
									
									table.insert(tlbMob.profile.loot.loot1,child);
								end
							elseif(mobProfile.attr.loot2  ~= nil) then
								lootRaw = mobProfile.attr.loot2;
								loot = nil;

								for loot in string.gmatch(lootRaw,LOOT_PATTERN) do
									local child = 
									{
										gsid = string.match(loot,"%[(%d+),");
										count = string.match(loot,",(%d+)%]=");
										rate = string.match(loot,"%d+[%.]?%d+$") .. "%";
									};	

									table.insert(tlbMob.profile.loot.loot2,child);
								end
							end

							if(self:ContainProfile(mobProfile.attr.displayname) == false) then
								print(mobProfile.attr.displayname);
								table.insert(self.MobDataTable,tlbMob);
							end

							if(self:ContainMob(mobProfile.attr.displayname) == false) then 
								table.insert(self.MobDataSet,{
									mobFile = mobProfile.attr.asset,
									mobName = mobProfile.attr.displayname
								});	
							end	
							
						end
					end
				end
			end
		end
	end -->end for arenas
end

--[[
	check whether contain one mob template
	@param:file path of mob
--]]
function MobWikiPage:ContainTemplate(name)
	local i,child = 0,nil;
	local hold = false;

	if self.MobDataTable == nil then 
		self.MobDataTable = {};
		return false;
	end

	for i,child in ipairs(self.MobDataTable) do
		if(child.fileName == name) then
			hold = true;
		end
	end

	return hold;
end

function MobWikiPage:ContainProfile(name)
	local i,child = 0,nil;
	local hold = false;

	if self.MobDataTable == nil then 
		self.MobDataTable = {};
		return false;
	end

	for i,child in ipairs(self.MobDataTable) do
		if(child.profile.mobName == name) then
			hold = true;
		end
	end

	return hold;
end

--[[
	check whether comming a new mob
	@param:the name of mob
--]]
function MobWikiPage:ContainMob(name)
	local i,child = 0,nil;
	local hold = false;

	if self.MobDataSet == nil then 
		self.MobDataSet = {};
		return false;
	end

	for i,child in ipairs(self.MobDataSet) do
		if(child.mobName == name) then
			hold = true;
		end
	end

	return hold;
end

--[[
	get mob profile by id,
	and show current selection mob
	@param: id ref to gsid
--]]
function MobWikiPage:MobSelection(id)

end

--[[
	export all mobs to comma separate values file
	@param: the file path to be saved for CSV file
--]]
function MobWikiPage:Export2CSV(path)
	if (self.MobDataTable == nil and table.getn(self.MobDataTable) == 0) then
		commonlib.echo("trying to export mob data to csv file,but no data to export.");
		return;
	end

	local path = path or EXPORT_FILE_PATH .. "MobData" .. ParaGlobal.GetDateFormat("_yyyy_MM_dd_") .. ParaGlobal.GetTimeFormat("hh.mm.ss") .. ".csv";
	
	if(ParaIO.DoesFileExist(path,false) == false) then
		ParaIO.CreateDirectory(path);
	end
	
	local fileObj = ParaIO.open(path, "w");
	local content,comma,newline = "",",","\n";
	local index,value = nil,nil;
	local GetItemByGsid = System.Item.ItemManager.GetGlobalStoreItemInMemory;

	--must write BOM header
	fileObj:WriteBytes(3,{239,187,191});

	--write header
	if(fileObj:IsValid()) then
		fileObj:WriteString("怪物名称," .. "掉落阶段," .. "掉落物品," .. "掉落个数,"  .. "掉落几率," .. newline);
	end

	for index,value in ipairs(self.MobDataTable) do
		local profile = value.profile;

		if(profile ~= nil) then
			local mobName = profile.mobName;
			if(self.MobExported[mobName] == nil or self.MobExported[mobName] == false) then
				self.MobExported[mobName] = true;

				if(mobName ~= nil and mobName ~= "") then
					content = content .. mobName .. comma;

					local loot = profile.loot;
				
					if(loot ~= nil) then
						local loot1,loot2 = loot.loot1,loot.loot2;

						content = content .. "loot1,";
						if(loot1 ~= nil and table.getn(loot1) > 0) then	
							local index,value = nil,nil;
							local i = 0;

							for index,value in ipairs(loot1) do
								if(i ~= 0 and index > i) then
									content = content ..",,";	
								end

								local gsItem = GetItemByGsid(tonumber(value.gsid));
								local lootName="";
								if(gsItem) then
									lootName = gsItem.template.name;
								end
								content = content .. lootName .. comma .. value.count .. comma .. value.rate .. comma .. newline;
								i = index;
							end
						else
							content = content .. "---,---,---,\n";
						end

						content = content .. ",loot2,";
						if(loot2 ~= nil and table.getn(loot2) > 0) then	
							local index,value = nil,nil;									
							local i = 0;

							for index,value in ipairs(loot2) do
								if(i ~= 0 and index > i) then
									content = content ..",,";	
								end

								local gsItem = GetItemByGsid(tonumber(value.gsid));
								local lootName="";
								if(gsItem) then
									lootName = gsItem.template.name;
								end
								content = content .. lootName .. comma .. value.count .. comma .. value.rate .. comma .. newline;
							
								i = index;
							end
						else
							content = content .. "---,---,---,\n";
						end
					end
				end		
			end
		end
	end
	if(fileObj:IsValid()) then
		fileObj:WriteString(content);
	end
	fileObj:close();

	--reset state for next export
	self.MobExported = {};
end

--[[
	close window
--]]
function MobWikiPage:Close()
	self.page:CloseWindow();
end