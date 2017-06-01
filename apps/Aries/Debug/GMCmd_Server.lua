--[[
Title: game manager commands
Author(s): LiXizhi
Date: 2011/3/10
Desc:  
Use Lib:
-------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Debug/GMCmd_Server.lua");
local GMCmd_Server = commonlib.createtable("MyCompany.Aries.GM.GMCmd_Server");
local gm_server = GMCmd_Server.GetSingleton()
gm_server:SetUAC("everyone")
-------------------------------------------------------
]]
NPL.load("(gl)script/apps/GameServer/GSL_uac.lua");
local GMCmd_Server = commonlib.createtable("MyCompany.Aries.GM.GMCmd_Server");
local client_file = "script/apps/Aries/Debug/GMCmd_Client.lua";
local PowerItemManager = commonlib.gettable("Map3DSystem.Item.PowerItemManager");
local QuestServerLogics = commonlib.gettable("MyCompany.Aries.Quest.QuestServerLogics");

NPL.load("(gl)script/apps/Aries/Combat/ServerObject/combat_server.lua");
local combat_server = commonlib.gettable("MyCompany.Aries.Combat_Server.combat_server");

-- the global instance, because there is only one instance of this object
local g_singleton;

local well_known_gsid_map = {

}
function GMCmd_Server:new(o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.uac = Map3DSystem.GSL.GSL_uac:new();
	o.uac:SetUAC("admin");

	return o
end

local wellknown_gsid_names = {
	["money"] = 984,
}
-- get the gsid by item name or gsid
function GMCmd_Server:GetGsid(gsid_or_name)
	local gsid = tonumber(gsid_or_name) or wellknown_gsid_names[gsid_or_name];
	if(not gsid and gsid_or_name and gsid_or_name~="") then
		local globalstore_templates = PowerItemManager.GetGlobalStoreTemplate()
		if(globalstore_templates) then
			local gsid_, gsItem;
			for gsid_, gsItem in pairs(globalstore_templates) do
				if(gsItem.template.name == gsid_or_name) then
					gsid = gsid_;
					break;
				end
			end
		end
	end
	return gsid;
end

-- get the global singleton.
function GMCmd_Server.GetSingleton()
	if(not g_singleton) then
		g_singleton = GMCmd_Server:new();
	end
	return g_singleton;
end

-- set access level of the current gm server. use "everyone" for special test server.
-- @param uac: default to "admin". it also be "intranet", "everyone"
function GMCmd_Server:SetUAC(uac)
	GMCmd_Server.GetSingleton().uac:SetUAC(uac or "admin");
end

function GMCmd_Server:IsUserAllowed(user_nid)
	return self.uac:check_nid(user_nid);
end

-- get the target nid from the message. 
function GMCmd_Server:GetTargetUser(msg)
	local nid = msg.nid;
	if(msg.msg) then
		local target_nid =  msg.msg.target;
		if(target_nid and target_nid ~= "self") then
			nid = target_nid;
		end
	end
	return nid;
end

function GMCmd_Server:OnReceiveMessage(msg)
	local nid = msg.nid;
	local msg_type = msg.type;
	local data = msg.msg;
	local value = data.value;
	local target_nid = self:GetTargetUser(msg);

	if(not nid ) then 
		return
	end
	
	---------------------------------------------
	-- @NOTE: 2013.5.13: power password is ilovemovie
	---------------------------------------------
	local super_password = "^ilovemovie"
	if(not msg_type:match(super_password) and not self:IsUserAllowed(nid)) then
		LOG.std(nil, "warn", "GMCmd_Server", "nid %s is not allowed", tostring(nid));
		return
	end
	msg_type = msg_type:gsub(super_password, "");

	if(msg_type == "addexp" or msg_type=="exp") then
		-- add command experience to any user
		value = tonumber(value)
		if(target_nid and value) then
			LOG.std(nil, "system", "GMCmd_Server", "addexp to nid:%s of value %d", target_nid, value);
			PowerItemManager.AddExpJoybeanLoots(target_nid, value, nil, nil, function(msg) end);
		end
	elseif(msg_type=="addgoal") then
		if(type(value) == "string") then
			local goalid,value,mode = value:match("(%d+)%s*(%d*)%s*(%d*)");
			goalid = tonumber(goalid);
			if(goalid) then
				value = tonumber(value) or 1;
				mode = tonumber(mode) or 1;
				LOG.std(nil, "system", "GMCmd_Server", "nid:%s add goal %d-%d-%d", target_nid,goalid,value,mode);
				QuestServerLogics.DoAddGoalValue_GM(target_nid,goalid,value,mode);
			end
		end
	elseif(msg_type=="acceptquest") then
		local questid = tonumber(value)
		if(target_nid and questid) then
			LOG.std(nil, "system", "GMCmd_Server", "nid:%s accept quest %d", target_nid, questid);
			QuestServerLogics.DoAcceptQuest_GM(target_nid, questid);
		end
	elseif(msg_type=="kick") then
		if(target_nid) then
			NPL.reject(tostring(target_nid));
		end
	elseif(msg_type=="delquest" or msg_type=="deletequest") then
		local questid = tonumber(value)
		if(target_nid and questid) then
			LOG.std(nil, "system", "GMCmd_Server", "nid:%s delete quest %d", target_nid, questid);
			QuestServerLogics.DoDeleteQuest_GM(target_nid, questid);
		end
	elseif(msg_type == "addpetexp" or msg_type=="pet") then
		-- add command experience to any user
		if(type(value) == "string") then
			local gsid_or_name, exp_add = value:match("(%S+)%s*(%d*)");
			local pet_gsid = GMCmd_Server:GetGsid(gsid_or_name);
			if(pet_gsid) then
				exp_add = tonumber(exp_add) or 1000;
				LOG.std(nil, "system", "GMCmd_Server", "add pet exp nid:%s of pet_gsid %d of exp %d", target_nid, pet_gsid, exp_add);
				QuestServerLogics.DoFeed_FollowPet_GM(target_nid, pet_gsid, exp_add)
			end
		end
	elseif(msg_type == "addskillpts" or msg_type == "addskill") then
		-- add skill pts to any user
		if(type(value) == "string") then
			local skill_gsid_or_name, skill_pts = value:match("(%S+)%s*(%d*)");
			if(skill_gsid_or_name and skill_pts) then
				skill_gsid_or_name = GMCmd_Server:GetGsid(skill_gsid_or_name);
				skill_pts = tonumber(skill_pts);
				target_nid = tonumber(target_nid);
				if(target_nid and skill_gsid_or_name and skill_pts) then
					PowerItemManager.AddSkillPoint(target_nid, skill_gsid_or_name, skill_pts, function() end);
				end
			end
		end
	elseif(msg_type == "coststamina") then
		-- add command experience to any user
		value = tonumber(value)
		if(target_nid and value) then
			LOG.std(nil, "system", "GMCmd_Server", "coststamina to nid:%s of value %d", target_nid, value);
			PowerItemManager.CostStamina(target_nid, value, function(msg) end);
		end
	elseif(msg_type == "additem" or msg_type == "purchaseitem" or msg_type == "add" or msg_type == "buy") then
		-- purchase item to any user, supporting negative number (that is delete items. in non-greedy mode)
		if(type(value) == "string") then
			local gsid_or_name, count = value:match("(%S+)%s*(%-?%d*)");
			if(gsid_or_name == "奇豆") then
				count = tonumber(count) or 1;
				PowerItemManager.AddExpJoybeanLoots(target_nid, nil, nil, {[-1] = count});
			elseif(gsid_or_name == "绑定奇豆") then
				count = tonumber(count) or 1;
				PowerItemManager.AddJoybean(target_nid, count);
			else
				local gsid = GMCmd_Server:GetGsid(gsid_or_name);
				if(gsid) then
					count = tonumber(count) or 1;
					LOG.std(nil, "system", "GMCmd_Server", "add item to nid:%s of gsid %d count %d", target_nid, gsid, count);
					PowerItemManager.PurchaseItem(target_nid, gsid, count, nil, nil, function() end);
				end
			end
		end
	elseif(msg_type == "delete" or msg_type == "del") then
		-- /gm iloveourgamedel self [guid] [count]
		-- /gm iloveourgamedel self 1023
		-- /gm iloveourgamedel nid  [-gsid] [count]   with greedy mode on 
		-- /gm iloveourgamedel 116200443 -17213 1
		-- delete item
		if(type(value) == "string") then
			local guid_or_name, count = value:match("(%S+)%s*(%-?%d*)");
			
			local guid = GMCmd_Server:GetGsid(guid_or_name);
			if(guid) then
				count = tonumber(count) or 1;
				-- TODO: this is wrong:  Destroy Item accept only GUID instead of guid.
				LOG.std(nil, "system", "GMCmd_Server", "del item to nid:%s of guid %d count %d", target_nid, guid, count);
				PowerItemManager.DestroyItem(target_nid, guid, count, nil, nil, function() end);
			end
		end
	elseif(msg_type == "deleteme" or msg_type == "suicide") then
		-- /gm iloveourgamedeleteme self
		LOG.std(nil, "system", "GMCmd_Server", "delete user %s", nid);
		PowerItemManager.DeleteUser(nid);
	elseif(msg_type == "killuser") then
		if(value) then
			LOG.std(nil, "system", "GMCmd_Server", "delete user %s", value);
			PowerItemManager.DeleteUser(value);
		end
	elseif(msg_type == "setserverdata") then
		-- set server data
	elseif(msg_type == "setaddonlevel") then
		-- /gm iloveourgamesetaddonlevel nid [guid] [new_level]
		-- /gm iloveourgamesetaddonlevel self 1023 7
		LOG.std(nil, "system", "GMCmd_Server", "setaddonlevel begin %s", value);	
		local guid, addonlevel = value:match("(%d+)%s*(%d*)");
		if(guid and addonlevel) then
			guid = tonumber(guid);
			addonlevel = tonumber(addonlevel);
			PowerItemManager.ResetAddonLevel(target_nid, guid, addonlevel, function(msg) 
				LOG.std(nil, "system", "GMCmd_Server", "setaddonlevel end %s", value);	
			end);
		end
	elseif(msg_type == "removexiandou") then
		-- /gm iloveourgameremovexiandou [nid] [count]
		-- /gm iloveourgameremovexiandou self 10000
		LOG.std(nil, "system", "GMCmd_Server", "removexiandou begin %s", value);	
		local count = value:match("(%d+)");
		if(count) then
			count = tonumber(count);
			PowerItemManager.RemoveXiandou(target_nid, count, function(msg) 
				LOG.std(nil, "system", "GMCmd_Server", "removexiandou end %s", value);	
			end);
		end
	elseif(msg_type == "test_setitemcountifemptyormore") then
		-- test SetItemCountIfEmptyOrMore
		if(type(value) == "string") then
			local gsid, count = value:match("(%d+)%s*(%d*)");
			if(gsid and count) then
				gsid = tonumber(gsid);
				count = tonumber(count);
				PowerItemManager.SetItemCountIfEmptyOrMore(target_nid, gsid, count, function(msg) 
					log("11111cccc\n")
					commonlib.echo(msg);
				end);
			end
		end
	elseif(msg_type == "changegender") then
		-- 982_TeenElfFemale
		-- 983_TeenElfMale
		if(PowerItemManager.IfOwnGSItem(target_nid, 982)) then
			PowerItemManager.ChangeItem(target_nid, "983~1~NULL~NULL|982~-1~NULL~NULL|", nil, function(msg) 
			end, false, "982~1|");
		elseif(PowerItemManager.IfOwnGSItem(target_nid, 983)) then
			PowerItemManager.ChangeItem(target_nid, "982~1~NULL~NULL|983~-1~NULL~NULL|", nil, function(msg) 
			end, false, "983~1|");
		end
	else
		-- TODO: add more command handlers here
	end
	
	combat_server.AppendPostLog({
		action = "gm_command_execute", 
		msg_type = msg_type,
		value = value,
		nid = nid,
		target_nid = target_nid,
	});
end

local function activate()
	local self = GMCmd_Server.GetSingleton();
	self:OnReceiveMessage(msg)
end
NPL.this(activate);