--[[
Title: CardQualityGSandXML
Author(s): WangTian
Date: 2012/10/5
Desc:  script/apps/Aries/Debug/CardQualityGSandXML.lua
Use Lib:
-------------------------------------------------------
-------------------------------------------------------
]]
local CardQualityGSandXML = commonlib.gettable("MyCompany.Aries.Debug.CardQualityGSandXML");

local MsgHandler = commonlib.gettable("MyCompany.Aries.Combat.MsgHandler");
local ItemManager = commonlib.gettable("Map3DSystem.Item.ItemManager");

NPL.load("(gl)script/apps/Aries/Combat/ServerObject/card_server.lua");
local Card = commonlib.gettable("MyCompany.Aries.Combat_Server.Card");

local output_xml_path = "config/Aries/Cards/Teen/AutoGen/";

local pending_cardlist_lines = {};

local addgs_from_gsid = 1;

CardQualityGSandXML.current_gen_gsid = addgs_from_gsid;

--GameServer.rest.client.CreateRESTJsonWrapper("test.auth.AuthUser", "AuthUser")
--NPL.AppendURLRequest(url, format("(%s)%s.callbackFunc(\"%s\")", npl_thread_name, fullname, tostring(id)), msg, requestPoolName or "r");
NPL.load("(gl)script/kids/3DMapSystemApp/API/webservice_wrapper.lua");

--paraworld.CreateHttpWrapper("paraworld.AddGS", "http://192.168.0.51:85/Admin/Items/Add.aspx")
paraworld.CreateHttpWrapper("paraworld.AddGS", "http://192.168.0.51:85/ashx/Items/AddGS")


local copy_from_gsid_begin = 5150;
local copy_from_gsid_end = 5159;
local copy_to_gsid_begin = 5236;


-- The data source for items
function CardQualityGSandXML.OnGenerate()
	pending_cardlist_lines = {};
	CardQualityGSandXML.current_gen_gsid = addgs_from_gsid;
	
	--local gsid;
	--for gsid = 22102, 22418 do
		--CardQualityGSandXML.GenerateCardQualityXMLConfigsFromSingleGSID(gsid);
	--end
	local gsid = copy_from_gsid_begin;

	local timer = commonlib.Timer:new({callbackFunc = function()
		if(gsid <= copy_from_gsid_end) then
			--CardQualityGSandXML.GenerateGSIDsFromSingleGSID(gsid);
			--CardQualityGSandXML.GenerateCardQualityXMLConfigsFromSingleGSID(gsid);
			--CardQualityGSandXML.ModifyGlobalStore_keys_values(gsid, {
				--stat_type_1 = 221,
				--stat_value_1 = 4,
			--});
			-- 5161¡ú5205
			local gsItem = ItemManager.GetGlobalStoreItemInMemory(gsid);
			if(gsItem) then
				local to_gsid = gsid + copy_to_gsid_begin - copy_from_gsid_begin;
				local to_key = string.gsub(gsItem.assetkey, ""..gsid, ""..to_gsid);
				CardQualityGSandXML.CopyGS_to_current(gsid, to_gsid, to_key, {});
			end
			_guihelper.MessageBox(tostring(gsid));
			gsid = gsid + 1;
		end
	end});
	timer:Change(0, 100);

	do return end

	local gsid = 22101;

	local timer = commonlib.Timer:new({callbackFunc = function()
		if(gsid <= 22418) then
			--CardQualityGSandXML.GenerateGSIDsFromSingleGSID(gsid);
			--CardQualityGSandXML.GenerateCardQualityXMLConfigsFromSingleGSID(gsid);
			_guihelper.MessageBox(tostring(gsid));
			gsid = gsid + 1;
		end
	end});
	timer:Change(0, 100);

	do return end
	
	local xml_path = output_xml_path.."___CardListPending.xml";
	local file = ParaIO.open(xml_path, "w");
	if(file:IsValid() == true) then
		local _, line;
		for _, line in ipairs(pending_cardlist_lines) do
			file:WriteString(line.."\n");
		end
		file:close();
	end
end

function CardQualityGSandXML.OnGenerateQualityGSIDFromWhiteCardGSID()
	
	local gsid = 22438;

	local timer = commonlib.Timer:new({callbackFunc = function()
		if(gsid <= 22441) then
			CardQualityGSandXML.GenerateGSIDsFromSingleGSID(gsid);
			--CardQualityGSandXML.GenerateCardQualityXMLConfigsFromSingleGSID(gsid);
			--CardQualityGSandXML.ModifyGlobalStore_keys_values(gsid, {
				--stat_type_1 = 221,
				--stat_value_1 = 4,
			--});
			_guihelper.MessageBox(tostring(gsid));
			gsid = gsid + 1;
		end
	end});
	timer:Change(0, 100);

end

function CardQualityGSandXML.GetFreeGSID()
	return CardQualityGSandXML.current_gen_gsid;
end

local firstline = [[<?xml version="1.0" encoding="utf-8"?>]];

local qualities = {
	"_Green",
	"_Blue",
	"_Purple",
	"_Orange",
};

-- NOTE: must run in Aries teen
-- NOTE: gsid is the white quality card gsid
function CardQualityGSandXML.GenerateCardQualityXMLConfigsFromSingleGSID(gsid)
	local gsItem = ItemManager.GetGlobalStoreItemInMemory(gsid);
	if(gsItem) then
		local gsid, cardkey = string.match(gsItem.assetkey, "^(%d-)_(.+)$");
		if(gsid and cardkey) then
			gsid = tonumber(gsid);
			if(gsItem.gsid == gsid) then
				MsgHandler.InitCardTemplateIfNot();
				local cardTemplate = Card.GetCardTemplate(cardkey);
				if(cardTemplate and cardTemplate.params) then
					-- read and write XML config
					local _, quality_str;
					for _, quality_str in ipairs(qualities) do
						local xml_path = output_xml_path..cardkey..quality_str..".xml";
						local file = ParaIO.open(xml_path, "w");
						if(file:IsValid() == true) then
							local hitchance_str = "";
							local require_level_str = "";
							if(cardTemplate.hitchance and cardTemplate.hitchance ~= 100) then
								hitchance_str = string.format([[ hitchance="%d"]], cardTemplate.hitchance);
							end
							if(cardTemplate.require_level and cardTemplate.require_level > 0) then
								require_level_str = string.format([[ require_level="%d"]], cardTemplate.require_level);
							end
							file:WriteString(firstline.."\n");
							file:WriteString(string.format([[<!-- %s%s AutoGen by CardQualityGSandXML -->]], gsItem.template.name, quality_str).."\n");
							file:WriteString([[<card>]].."\n");
							file:WriteString(string.format([[  <key name="%s"/>]], cardkey..quality_str).."\n");
							file:WriteString(string.format([[  <spell name="%s"/>]], cardTemplate.spell_name).."\n");
							file:WriteString([[  <!--following is basic params-->]].."\n");
							file:WriteString(string.format([[  <basics type="%s" pipcost="%d" accuracy="100" spell_school="%s"%s%s/>]], 
								cardTemplate.type, 
								cardTemplate.pipcost, 
								cardTemplate.spell_school,
								hitchance_str,
								require_level_str).."\n");
							file:WriteString([[  <!--following is the spell template specific params-->]].."\n");
							file:WriteString([[  <params ]]);
							local isFirst = true;
							local key, value;
							for key, value in pairs(cardTemplate.params) do
								local this_value = value;

								if((key == "damage_min" or key == "damage_max" or key == "heal_min" or key == "heal_max") and type(this_value) == "number") then
									if(not string.find(string.lower(cardkey), "_rune_")) then
										-- skip rune cards
										local scale = 1;
										if(quality_str == "_Green") then
											scale = 1.05;
										elseif(quality_str == "_Blue") then
											scale = 1.1;
										elseif(quality_str == "_Purple") then
											scale = 1.15;
										elseif(quality_str == "_Orange") then
											scale = 1.2;
										end
										this_value = math.ceil(this_value * scale);
									end
								elseif(key == "charm" or key == "ward" or key == "charms" or key == "wards") then
									local this_value_number = tonumber(this_value);
									if(not this_value_number) then
										if(this_value == "27,27,27,27") then -- Ice_Rune_MultipleGlobalShield
											if(quality_str == "_Green") then
												this_value = "1027,1027,1027,1027";
											elseif(quality_str == "_Blue") then
												this_value = "2027,2027,2027,2027";
											elseif(quality_str == "_Purple") then
												this_value = "3027,3027,3027,3027";
											elseif(quality_str == "_Orange") then
												this_value = "4027,4027,4027,4027";
											end
										else
											log("1111111ccccc error key value in CardQualityGSandXML\n")
											commonlib.echo(cardkey)
											commonlib.echo({key, this_value});
										end
									else
										if(quality_str == "_Green") then
											this_value = this_value_number + 1000;
										elseif(quality_str == "_Blue") then
											this_value = this_value_number + 2000;
										elseif(quality_str == "_Purple") then
											this_value = this_value_number + 3000;
										elseif(quality_str == "_Orange") then
											this_value = this_value_number + 4000;
										end
									end
								elseif(key == "miniaura") then
									local this_value_number = tonumber(this_value);
									if(quality_str == "_Green") then
										this_value = this_value_number + 1000;
									elseif(quality_str == "_Blue") then
										this_value = this_value_number + 2000;
									elseif(quality_str == "_Purple") then
										this_value = this_value_number + 3000;
									elseif(quality_str == "_Orange") then
										this_value = this_value_number + 4000;
									end
								end

								if(isFirst) then
									file:WriteString(string.format([[%s="%s"]], key, tostring(this_value)).."\n");
									isFirst = false;
								else
									file:WriteString(string.format([[          %s="%s"]], key, tostring(this_value)).."\n");
								end
							end
							file:WriteString([[  />]].."\n");
							file:WriteString([[</card>]].."\n");

							file:close();
							
							-- update to GS
							local to_gsid = gsid;
							if(quality_str == "_Green") then
								to_gsid = gsid + 41000 - 22000;
							elseif(quality_str == "_Blue") then
								to_gsid = gsid + 42000 - 22000;
							elseif(quality_str == "_Purple") then
								to_gsid = gsid + 43000 - 22000;
							elseif(quality_str == "_Orange") then
								to_gsid = gsid + 44000 - 22000;
							end
							--CardQualityGSandXML.CopyGS_to_current(gsid, to_gsid, cardkey..quality_str);

							table.insert(pending_cardlist_lines, string.format([[<card datafile="config/Aries/Cards/Teen/%s.xml"/>]], cardkey..quality_str));
						end
					end
				end
			end
		end
	end
end

function CardQualityGSandXML.DuplicateCharmWardList()
	local file_path = "config/Aries/Cards/CharmWardList.teen.xml";
	local file = ParaIO.open(file_path, "r");
	local newfile_lines = {};
	if(file:IsValid() == true) then
		-- read a line 
		local line = file:readline();
		while(line) do
			if(string.find(line, "<charm id")) then
				local id = string.match(line, [[<charm id="(%d+)"]]);
				if(id and tonumber(id)) then
					id = tonumber(id);
					local newline = string.gsub(line, [[<charm id="]]..id..[["]], [[<charm id = "]]..id..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<charm id="]]..id..[["]], [[<charm id="]]..(id+1000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<charm id="]]..id..[["]], [[<charm id="]]..(id+2000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<charm id="]]..id..[["]], [[<charm id="]]..(id+3000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<charm id="]]..id..[["]], [[<charm id="]]..(id+4000)..[["]]);
					table.insert(newfile_lines, newline);
				end
			elseif(string.find(line, "<ward id")) then
				local id = string.match(line, [[<ward id="(%d+)"]]);
				if(id and tonumber(id)) then
					id = tonumber(id);
					local newline = string.gsub(line, [[<ward id="]]..id..[["]], [[<ward id = "]]..id..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<ward id="]]..id..[["]], [[<ward id="]]..(id+1000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<ward id="]]..id..[["]], [[<ward id="]]..(id+2000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<ward id="]]..id..[["]], [[<ward id="]]..(id+3000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<ward id="]]..id..[["]], [[<ward id="]]..(id+4000)..[["]]);
					table.insert(newfile_lines, newline);
				end
			elseif(string.find(line, "<miniaura id")) then
				local id = string.match(line, [[<miniaura id="(%d+)"]]);
				if(id and tonumber(id)) then
					id = tonumber(id);
					local newline = string.gsub(line, [[<miniaura id="]]..id..[["]], [[<miniaura id = "]]..id..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<miniaura id="]]..id..[["]], [[<miniaura id="]]..(id+1000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<miniaura id="]]..id..[["]], [[<miniaura id="]]..(id+2000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<miniaura id="]]..id..[["]], [[<miniaura id="]]..(id+3000)..[["]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[<miniaura id="]]..id..[["]], [[<miniaura id="]]..(id+4000)..[["]]);
					table.insert(newfile_lines, newline);
				end
			else
				table.insert(newfile_lines, line);
			end
			line = file:readline();
		end
		file:close();
	end
	
	local xml_path = output_xml_path.."___CharmWardList.teen.xml";
	local file = ParaIO.open(xml_path, "w");
	if(file:IsValid() == true) then
		local _, line;
		for _, line in ipairs(newfile_lines) do
			file:WriteString(line.."\n");
		end
		file:close();
	end
end


function CardQualityGSandXML.AdjustCharmWardListCard_gsid()
	local file_path = "config/Aries/Cards/CharmWardList.teen.xml";
	local file = ParaIO.open(file_path, "r");
	local newfile_lines = {};
	if(file:IsValid() == true) then
		-- read a line 
		local line = file:readline();
		while(line) do
			local id = string.match(line, [[<charm id="(%d+)"]]);
			local icon_gsid = string.match(line, [[icon_gsid="(%d+)"]]);
			if(id and tonumber(id) and icon_gsid and tonumber(icon_gsid)) then
				id = tonumber(id);
				icon_gsid = tonumber(icon_gsid);
				local old_pattern = [[icon_gsid="]]..icon_gsid..[["]];
				if(id > 1000 and id < 1999) then
					icon_gsid = math.mod(icon_gsid, 1000) + 41000;
				elseif(id > 2000 and id < 2999) then
					icon_gsid = math.mod(icon_gsid, 1000) + 42000;
				elseif(id > 3000 and id < 3999) then
					icon_gsid = math.mod(icon_gsid, 1000) + 43000;
				elseif(id > 4000 and id < 4999) then
					icon_gsid = math.mod(icon_gsid, 1000) + 44000;
				end

				local newline = string.gsub(line, old_pattern, [[icon_gsid="]]..icon_gsid..[["]]);
				table.insert(newfile_lines, newline);
			else
				table.insert(newfile_lines, line);
			end
			line = file:readline();
		end
		file:close();
	end
	
	local xml_path = output_xml_path.."___CharmWardList.teen.xml";
	local file = ParaIO.open(xml_path, "w");
	if(file:IsValid() == true) then
		local _, line;
		for _, line in ipairs(newfile_lines) do
			file:WriteString(line.."\n");
		end
		file:close();
	end
end

function CardQualityGSandXML.DuplicateCardList()
	local file_path = "config/Aries/Cards/CardList.teen.xml";
	local file = ParaIO.open(file_path, "r");
	local newfile_lines = {};
	if(file:IsValid() == true) then
		-- read a line 
		local line = file:readline();
		while(line) do
			if(string.find(line, "Fire_") or string.find(line, "Ice_") or string.find(line, "Storm_")
				 or string.find(line, "Myth_") or string.find(line, "Life_") or string.find(line, "Death_") or string.find(line, "Balance_")) then
				if(true) then
					local newline = string.gsub(line, [[.xml]], [[.xml]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[.xml]], [[_Green.xml]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[.xml]], [[_Blue.xml]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[.xml]], [[_Purple.xml]]);
					table.insert(newfile_lines, newline);
					local newline = string.gsub(line, [[.xml]], [[_Orange.xml]]);
					table.insert(newfile_lines, newline);
				end
			else
				table.insert(newfile_lines, line);
			end
			line = file:readline();
		end
		file:close();
	end
	
	local xml_path = output_xml_path.."___CardList.teen.xml";
	local file = ParaIO.open(xml_path, "w");
	if(file:IsValid() == true) then
		local _, line;
		for _, line in ipairs(newfile_lines) do
			file:WriteString(line.."\n");
		end
		file:close();
	end
end

function CardQualityGSandXML.RemoveRuneQualityFromCardList()
	local file_path = "config/Aries/Cards/CardList.teen.xml";
	local file = ParaIO.open(file_path, "r");
	local newfile_lines = {};
	if(file:IsValid() == true) then
		-- read a line 
		local line = file:readline();
		while(line) do
			if(string.find(line, "_Rune_")) then
				if(string.find(line, "_Green.xml")) then
				elseif(string.find(line, "_Blue.xml")) then
				elseif(string.find(line, "_Purple.xml")) then
				elseif(string.find(line, "_Orange.xml")) then
				else
					table.insert(newfile_lines, line);
				end
			else
				table.insert(newfile_lines, line);
			end
			line = file:readline();
		end
		file:close();
	end
	
	local xml_path = output_xml_path.."___CardList.teen.xml";
	local file = ParaIO.open(xml_path, "w");
	if(file:IsValid() == true) then
		local _, line;
		for _, line in ipairs(newfile_lines) do
			file:WriteString(line.."\n");
		end
		file:close();
	end
end

function CardQualityGSandXML.DuplicateRuneQualityToCardList()
	local file_path = "config/Aries/Cards/CardList.teen.xml";
	local file = ParaIO.open(file_path, "r");
	local newfile_lines = {};
	if(file:IsValid() == true) then
		-- read a line 
		local line = file:readline();
		while(line) do
			if(string.find(line, "_Rune_")) then
				table.insert(newfile_lines, line);
				local line_with_quality = string.gsub(line, ".xml", "_Green.xml");
				table.insert(newfile_lines, line_with_quality);
				local line_with_quality = string.gsub(line, ".xml", "_Blue.xml");
				table.insert(newfile_lines, line_with_quality);
				local line_with_quality = string.gsub(line, ".xml", "_Purple.xml");
				table.insert(newfile_lines, line_with_quality);
				local line_with_quality = string.gsub(line, ".xml", "_Orange.xml");
				table.insert(newfile_lines, line_with_quality);
			else
				table.insert(newfile_lines, line);
			end
			line = file:readline();
		end
		file:close();
	end
	
	local xml_path = output_xml_path.."___CardList.teen.xml";
	local file = ParaIO.open(xml_path, "w");
	if(file:IsValid() == true) then
		local _, line;
		for _, line in ipairs(newfile_lines) do
			file:WriteString(line.."\n");
		end
		file:close();
	end
end


-- NOTE: must run in Aries teen
function CardQualityGSandXML.AssignStats36ForApparels()
	
	pending_cardlist_lines = {};
	CardQualityGSandXML.current_gen_gsid = addgs_from_gsid;
	
	--local gsid;
	--for gsid = 22102, 22418 do
		--CardQualityGSandXML.GenerateCardQualityXMLConfigsFromSingleGSID(gsid);
	--end
	local gsid = 1001;

	local function IsInEquipGroup(subclass)
		--local equip_group = {2,5,6,7,8,9,12,18,19,70,71,10,11};
		local equip_group = {2,5,6,7,8,9,12,10,11};
		local _, __
		for _, __ in pairs(equip_group) do
			if(__ == subclass) then
				return true;
			end
		end
		return false
	end
	
	local function IsInAccessoriesGroup(subclass)
		local accessories_group = {14,15,16,17};
		local _, __
		for _, __ in pairs(accessories_group) do
			if(__ == subclass) then
				return true;
			end
		end
		return false
	end

	local log_lines = {};

	local timer = commonlib.Timer:new({callbackFunc = function()
		if(gsid <= 4999) then
			local gsItem = ItemManager.GetGlobalStoreItemInMemory(gsid);
			if(gsItem) then
				local quality = gsItem.template.stats[221];
				local required_level = gsItem.template.stats[138];
				if(quality > 0 and required_level) then
					local gem_slot_count;
					if(gsItem.template.class == 1 and IsInEquipGroup(gsItem.template.subclass)) then
						if(required_level >= 0 and required_level <= 9)then 
							gem_slot_count = 1;
						elseif(required_level >= 10 and required_level <= 19)then 
							gem_slot_count = 1;
						elseif(required_level >= 20 and required_level <= 29)then 
							gem_slot_count = 2;
						elseif(required_level >= 30 and required_level <= 39)then 
							gem_slot_count = 3;
						elseif(required_level >= 40 and required_level <= 49)then 
							gem_slot_count = 4;
						elseif(required_level >= 50 and required_level <= 59)then 
							gem_slot_count = 5;
						end
					elseif(gsItem.template.class == 1 and IsInAccessoriesGroup(gsItem.template.subclass)) then
						if(required_level >= 0 and required_level <= 9)then 
							gem_slot_count = 1;
						elseif(required_level >= 10 and required_level <= 19)then 
							gem_slot_count = 1;
						elseif(required_level >= 20 and required_level <= 29)then 
							gem_slot_count = 1;
						elseif(required_level >= 30 and required_level <= 39)then 
							gem_slot_count = 1;
						elseif(required_level >= 40 and required_level <= 49)then 
							gem_slot_count = 2;
						elseif(required_level >= 50 and required_level <= 59)then 
							gem_slot_count = 2;
						end
					end
					if(gem_slot_count and (gsItem.template.stat_type_10 == 0 and gsItem.template.stat_value_10 == 0)) then
						--commonlib.echo({})
						-- echo:{1076,4,40,11,}
						local log_line = gsid.."_"..gem_slot_count.."_"..required_level.."_"..gsItem.template.subclass.."\n";
						CardQualityGSandXML.ModifyGlobalStore_keys_values(gsid, {
							stat_type_10 = 36,
							stat_value_10 = gem_slot_count,
						});
						table.insert(log_lines, log_line)
					end
					_guihelper.MessageBox(tostring(gsid));
				end
			else
				_guihelper.MessageBox(tostring(gsid).."...");
			end
			gsid = gsid + 1;
			if(gsid == 4999) then
				log("111111111ccccccccccccc\n")
				local _, line;
				for _, line in ipairs(log_lines) do
					log(line);
				end
			end
		end
	end});

	timer:Change(0, 100);
end

-- NOTE: must run in Aries teen
-- NOTE: gsid is the white quality card gsid
function CardQualityGSandXML.GenerateGSIDsFromSingleGSID(gsid)
	local gsItem = ItemManager.GetGlobalStoreItemInMemory(gsid);
	if(gsItem) then
		local modified_fields = {};
		local _, cardkey = string.match(gsItem.assetkey, "^(%d-)_(.+)$");
		if(_ and cardkey) then
			local _, quality_str;
			for _, quality_str in ipairs(qualities) do
				local to_gsid = gsid;
				if(quality_str == "_Green") then
					to_gsid = gsid + 41000 - 22000;
					modified_fields = {Stat_type_1 = 221, Stat_value_1 = 1};
				elseif(quality_str == "_Blue") then
					to_gsid = gsid + 42000 - 22000;
					modified_fields = {Stat_type_1 = 221, Stat_value_1 = 2};
				elseif(quality_str == "_Purple") then
					to_gsid = gsid + 43000 - 22000;
					modified_fields = {Stat_type_1 = 221, Stat_value_1 = 3};
				elseif(quality_str == "_Orange") then
					to_gsid = gsid + 44000 - 22000;
					modified_fields = {Stat_type_1 = 221, Stat_value_1 = 4};
				end
				CardQualityGSandXML.CopyGS_to_current(gsid, to_gsid, cardkey..quality_str, modified_fields);
			end
		end
	end
end

local pool_params = {};

function CardQualityGSandXML.CopyGS_to_current(from_gsid, to_gsid, to_key, modified_fields)
	
	table.insert(pool_params, {from_gsid, to_gsid, to_key, modified_fields});

	CardQualityGSandXML.Trigger()
end

function CardQualityGSandXML.Trigger()
	
	local from_gsid, to_gsid, to_key, modified_fields;
	if(not pool_params.nProcessing) then
		local _, params;
		for _, params in ipairs(pool_params) do
			if(not params.bDone) then
				from_gsid, to_gsid, to_key, modified_fields = params[1], params[2], params[3], params[4];
				pool_params.nProcessing = _;
				break;
			end
		end
	end
	
	if(from_gsid and to_gsid and to_key and modified_fields) then
		local gsItem = ItemManager.GetGlobalStoreItemInMemory(from_gsid);
		if(gsItem) then
			local gsid, cardkey = string.match(gsItem.assetkey, "^(%d-)_(.+)$");
			if(gsid and cardkey) then
				gsid = tonumber(gsid);
				if(gsItem.gsid == gsid) then
					local msg = {};
					-- copy base params
					msg.DescFile = gsItem.descfile;
					msg.Type = gsItem.type;
					msg.Category = gsItem.category;
					msg.Count = gsItem.count;
					msg.Icon = gsItem.icon;
					msg.PBuyPrice = gsItem.pbuyprice;
					msg.EBuyPrice = gsItem.ebuyprice;
					msg.PSellPrice = gsItem.psellprice;
					msg.ESellPrice = gsItem.esellprice;
					msg.ESellRandomBonus = gsItem.esellrandombonus;
					msg.MaxDailyCount = gsItem.maxdailycount;
					msg.MaxWeeklyCount = gsItem.maxweeklycount;
					msg.HourlyLimitedPurchase = gsItem.hourlylimitedpurchase;
					msg.DailyLimitedPurchase = gsItem.dailylimitedpurchase;
					-- template
					msg.Class = gsItem.template.class;
					msg.Subclass = gsItem.template.subclass;
					msg.Name = gsItem.template.name;
					msg.InventoryType = gsItem.template.inventorytype;
					msg.MaxCount = gsItem.template.maxcount;
					msg.MaxCopiesInStack = gsItem.template.maxcopiesinstack;
					msg.StatsCount = gsItem.template.statscount;
					msg.Stat_type_1 = gsItem.template.stat_type_1;
					msg.Stat_type_2 = gsItem.template.stat_type_2;
					msg.Stat_type_3 = gsItem.template.stat_type_3;
					msg.Stat_type_4 = gsItem.template.stat_type_4;
					msg.Stat_type_5 = gsItem.template.stat_type_5;
					msg.Stat_type_6 = gsItem.template.stat_type_6;
					msg.Stat_type_7 = gsItem.template.stat_type_7;
					msg.Stat_type_8 = gsItem.template.stat_type_8;
					msg.Stat_type_9 = gsItem.template.stat_type_9;
					msg.Stat_type_10 = gsItem.template.stat_type_10;
					msg.Stat_value_1 = gsItem.template.stat_value_1;
					msg.Stat_value_2 = gsItem.template.stat_value_2;
					msg.Stat_value_3 = gsItem.template.stat_value_3;
					msg.Stat_value_4 = gsItem.template.stat_value_4;
					msg.Stat_value_5 = gsItem.template.stat_value_5;
					msg.Stat_value_6 = gsItem.template.stat_value_6;
					msg.Stat_value_7 = gsItem.template.stat_value_7;
					msg.Stat_value_8 = gsItem.template.stat_value_8;
					msg.Stat_value_9 = gsItem.template.stat_value_9;
					msg.Stat_value_10 = gsItem.template.stat_value_10;
					msg.Description = gsItem.template.description;
					msg.CanUseDirectly = if_else(gsItem.template.canusedirectly, "1", "0");
					msg.DestroyAfterUse = if_else(gsItem.template.destroyafteruse, "1", "0");
					msg.CanSell = if_else(gsItem.template.cansell, "1", "0");
					msg.CanExchange = if_else(gsItem.template.canexchange, "1", "0");
					msg.CanGift = if_else(gsItem.template.cangift, "1", "0");
					msg.RequirePayment = gsItem.template.requirepayment;
					msg.ExpireType = gsItem.template.expiretype;
					msg.ExpireTime = gsItem.template.expiretime;
					--msg.ExpireDate = "2012-09-26 10:10:10";
					msg.DestroyAfterExpire = gsItem.template.DestroyAfterExpire; ----
					msg.Rechargeable = if_else(gsItem.template.rechargeable, "1", "0");
					msg.Material = gsItem.template.material;
					msg.ItemSetID = gsItem.template.itemsetid;
					msg.BagFamily = gsItem.template.bagfamily;


					-- NOTE: set the item gsid and keys
					msg.gsid = to_gsid;
					--msg.isedit = "true";
					msg.AssetKey = to_gsid.."_"..to_key;
					msg.AssetFile = to_gsid.."_"..to_key;

					if(modified_fields) then
						local stat_key, stat_value;
						for stat_key, stat_value in pairs(modified_fields) do
							msg[stat_key] = stat_value;
						end
					end

					paraworld.globalstore.read({gsids = tostring(to_gsid)}, "test_validate", function(output_msg)
						if(output_msg and output_msg.globalstoreitems and output_msg.globalstoreitems[1]) then
							msg.isedit = "true";
							log("---------------------- edit gsid:"..msg.gsid.."----------------------\n");
						else
							msg.isedit = "false";
							log("---------------------- append gsid:"..msg.gsid.."----------------------\n");
						end
						--if(msg.gsid >= 22101 and msg.gsid <= 22999) then
						--if(msg.gsid >= 1 and msg.gsid <= 4) then
						--if(msg.gsid >= 41000 and msg.gsid <= 45000) then
						
						if(msg.gsid >= copy_to_gsid_begin and msg.gsid <= (copy_to_gsid_begin + (copy_from_gsid_end - copy_from_gsid_begin))) then
							--local remaining = math.mod(msg.gsid, 1000);
							--if(remaining >= 438 and remaining <= 441) then
								paraworld.AddGS(msg, "CopyGS_to_current", function(msg)
									pool_params[pool_params.nProcessing].bDone = true;
									pool_params.nProcessing = nil;
									CardQualityGSandXML.Trigger();
								end);
							--end
						end
					end);
				end
			end
		end
	end
end


function CardQualityGSandXML.ModifyGlobalStore(gsid)
	local gsItem = ItemManager.GetGlobalStoreItemInMemory(gsid);
	if(gsItem) then
		local msg = {};
		msg.gsid = gsid;
		msg.isedit = "true";
		msg.AssetKey = gsItem.assetkey;
		msg.AssetFile = gsItem.assetfile;
		-- copy base params
		msg.DescFile = gsItem.descfile;
		msg.Type = gsItem.type;
		msg.Category = gsItem.category;
		msg.Count = gsItem.count;
		msg.Icon = gsItem.icon;
		msg.PBuyPrice = gsItem.pbuyprice;
		msg.EBuyPrice = gsItem.ebuyprice;
		msg.PSellPrice = gsItem.psellprice;
		msg.ESellPrice = gsItem.esellprice;
		msg.ESellRandomBonus = gsItem.esellrandombonus;
		msg.MaxDailyCount = gsItem.maxdailycount;
		msg.MaxWeeklyCount = gsItem.maxweeklycount;
		msg.HourlyLimitedPurchase = gsItem.hourlylimitedpurchase;
		msg.DailyLimitedPurchase = gsItem.dailylimitedpurchase;
		-- template
		msg.Class = gsItem.template.class;
		msg.Subclass = gsItem.template.subclass;
		msg.Name = gsItem.template.name;
		msg.InventoryType = gsItem.template.inventorytype;
		msg.MaxCount = gsItem.template.maxcount;
		msg.MaxCopiesInStack = gsItem.template.maxcopiesinstack;
		msg.StatsCount = gsItem.template.statscount;
		msg.Stat_type_1 = gsItem.template.stat_type_1;
		msg.Stat_type_2 = gsItem.template.stat_type_2;
		msg.Stat_type_3 = gsItem.template.stat_type_3;
		msg.Stat_type_4 = gsItem.template.stat_type_4;
		msg.Stat_type_5 = gsItem.template.stat_type_5;
		msg.Stat_type_6 = gsItem.template.stat_type_6;
		msg.Stat_type_7 = gsItem.template.stat_type_7;
		msg.Stat_type_8 = gsItem.template.stat_type_8;
		msg.Stat_type_9 = gsItem.template.stat_type_9;
		msg.Stat_type_10 = gsItem.template.stat_type_10;
		msg.Stat_value_1 = gsItem.template.stat_value_1;
		msg.Stat_value_2 = gsItem.template.stat_value_2;
		msg.Stat_value_3 = gsItem.template.stat_value_3;
		msg.Stat_value_4 = gsItem.template.stat_value_4;
		msg.Stat_value_5 = gsItem.template.stat_value_5;
		msg.Stat_value_6 = gsItem.template.stat_value_6;
		msg.Stat_value_7 = gsItem.template.stat_value_7;
		msg.Stat_value_8 = gsItem.template.stat_value_8;
		msg.Stat_value_9 = gsItem.template.stat_value_9;
		msg.Stat_value_10 = gsItem.template.stat_value_10;
		msg.Description = gsItem.template.description;
		msg.CanUseDirectly = if_else(gsItem.template.canusedirectly, "1", "0");
		msg.DestroyAfterUse = if_else(gsItem.template.destroyafteruse, "1", "0");
		msg.CanSell = if_else(gsItem.template.cansell, "1", "0");
		msg.CanExchange = if_else(gsItem.template.canexchange, "1", "0");
		msg.CanGift = if_else(gsItem.template.cangift, "1", "0");
		msg.RequirePayment = gsItem.template.requirepayment;
		msg.ExpireType = gsItem.template.expiretype;
		msg.ExpireTime = gsItem.template.expiretime;
		--msg.ExpireDate = "2012-09-26 10:10:10";
		msg.DestroyAfterExpire = gsItem.template.DestroyAfterExpire; ----
		msg.Rechargeable = if_else(gsItem.template.rechargeable, "1", "0");
		msg.Material = gsItem.template.material;
		msg.ItemSetID = gsItem.template.itemsetid;
		msg.BagFamily = gsItem.template.bagfamily;

		--if(msg.gsid >= 41000 and msg.gsid <= 45000) then
		if(msg.gsid >= 1001 and msg.gsid <= 4999) then
			paraworld.AddGS(msg, "CopyGS_to_current", function(msg)
				pool_params[pool_params.nProcessing].bDone = true;
				pool_params.nProcessing = nil;
				CardQualityGSandXML.Trigger();
			end);
		end
	end
end

function CardQualityGSandXML.ModifyGlobalStore_keys_values(gsid, stats)
	local msg = {};
	msg.gsid = gsid;
	msg.isedit = "true";
	local k, v;
	for k, v in pairs(stats) do
		msg[k] = v;
	end
	--if((msg.gsid >= 22000 and msg.gsid <= 24000) or (msg.gsid >= 41000 and msg.gsid <= 45000)) then
	--if(msg.gsid >= 1001 and msg.gsid <= 4999) then
	if(msg.gsid >= 41000 and msg.gsid <= 45000) then
		local remaining = math.mod(msg.gsid, 1000);
		if(remaining >= 419 and remaining <= 437) then
			paraworld.AddGS(msg, "CopyGS_to_current", function(msg)
			
			end);
		end
	end
end