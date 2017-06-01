--[[
Title: game manager commands
Author(s): LiXizhi
Date: 2011/3/10
Desc:  All commands are defined on the server side file GMCmd_Server.lua. 
This client gm commands simply forward command to server for processing. 
Use Lib:
-------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Debug/GMCmd_Client.lua");
local GMCmd_Client = commonlib.gettable("MyCompany.Aries.GM.GMCmd_Client");
local gm_client = GMCmd_Client.GetSingleton();
gm_client:Run("addexp self 100");
gm_client:Run("addexp 100");
gm_client:Run("additem self {a=1,b=2}");
gm_client:Run("additem {a=1,b=2}"); 
gm_client:SendMessage("addexp", {target="self", value="100"});
-------------------------------------------------------
]]
local SlashCommand = commonlib.gettable("MyCompany.Aries.SlashCommand.SlashCommand");
local GMCmd_Client = commonlib.gettable("MyCompany.Aries.GM.GMCmd_Client");
local proxy_addr_templ = "(%s)%s:script/apps/Aries/Debug/GMCmd_Server.lua";

-- the global instance, because there is only one instance of this object
local g_singleton;

function GMCmd_Client:new(o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	-- each client must be associated with a gsl client object, even if none is provided.
	o:SetClient();
	return o
end

-- set the gsl client object
-- @param client: if nil it is the global default client object. 
function GMCmd_Client:SetClient(client)
	self.client = client or commonlib.gettable("Map3DSystem.GSL_client");
end

-- get the global singleton.
function GMCmd_Client.GetSingleton()
	if(not g_singleton) then
		g_singleton = GMCmd_Client:new();
	end
	return g_singleton;
end

-- register slash command
function GMCmd_Client:Register(slash_command)
	LOG.std(nil, "system", "SlashCommand", "all GM module commands registered");

	-- gm command
	slash_command:RegisterSlashCommand({name="gm", quick_ref="/gm cmd_name cmd_params", desc="game master commands", handler = function(cmd_name, cmd_text, cmd_params)
		self:Run(cmd_text);
		return "";
	end});
end

-- start a given command string
-- @param cmd_str: the string is of format 
--   cmd_name [cmd_target] [any_numer_string_or_table_format]
-- e.g. "addexp self 100" --> msg {type="addexp", data={target="self", value=100}}
--      "addexp 100" --> msg {type="addexp", data={value="100"}}
--      "additem 123_nid {a=1,b=2}" --> msg {type="additem", data={target="123_nid",a=1, b=2}}
--      "additem {a=1,b=2}" --> msg {type="additem", data={a=1, b=2}}
function GMCmd_Client:Run(cmd_str)
	-- cmd name
	local cmd_name, cmd_next = string.match(cmd_str, "^(%S+)%s*(.*)$");
	if(not cmd_name) then
		return 
	else
		local cmd_params = SlashCommand:ParseParamsFromCmd(cmd_next);
		self:SendMessage(cmd_name, cmd_params);
	end
end

function GMCmd_Client:SendMessage(msg_type, msg_data)
	LOG.std(nil, "debug", "GMCmd_Client", "send type %s: data:%s", tostring(msg_type), commonlib.serialize_compact(msg_data));

	if(not self.client) then
		LOG.std(nil, "error", "GMCmd_Client", "no gsl client is found");
		return
	end
	-- game server address
	self.proxy_address = format(proxy_addr_templ, self.client.worldserver_id, self.client.gameserver_nid);

	if( NPL.activate(self.proxy_address, {type = msg_type, msg = msg_data}) ~=0 ) then
		-- connection to server may be lost
		LOG.std("", "warning", "GMCmd_Client", "unable to send request to "..self.proxy_address);
	end
end

function GMCmd_Client:OnReceiveMessage(msg)
	LOG.std(nil, "debug", "GMCmd_Client", "receive: "..commonlib.serialize_compact(msg));
	local msg_type = msg.type;
	if(msg_type == "gm_done") then
	end
end

local function activate()
	local self = GMCmd_Client.GetSingleton();
	self:OnReceiveMessage(msg)
end
NPL.this(activate);