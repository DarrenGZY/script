--[[
Title: an unknown item
Author(s): WangTian, originally drafted by LiXizhi
Date: 2009/2/12
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)script/kids/3DMapSystemItem/Exe_AppCommand.lua");
local dummyItem = Map3DSystem.Item.Exe_AppCommand:new({AppCommand="File.Exit", params=nil});
Map3DSystem.Item.ItemManager:AddItem(dummyItem);
------------------------------------------------------------
]]

NPL.load("(gl)script/kids/3DMapSystemItem/ItemBase.lua");

local Exe_AppCommand = commonlib.inherit(Map3DSystem.Item.ItemBase, {type=Map3DSystem.Item.Types.AppCommand});
commonlib.setfield("Map3DSystem.Item.Exe_AppCommand", Exe_AppCommand)

---------------------------------
-- functions
---------------------------------


-- Get the Icon of this object
-- @param callbackFunc: function (filename) end. if nil, it will return the icon texture path. otherwise it will use the callback,since the icon may not be immediately available at call time.  
function Exe_AppCommand:GetIcon(callbackFunc)
	if(self.icon) then
		return self.icon;
	elseif(self.AppCommand or self.cmd) then
		
		self.cmd = self.cmd or Map3DSystem.App.Commands.GetCommand(self.AppCommand)
		if(self.cmd) then
			self.icon = self.cmd.icon;
			return self.icon;
		end	
	else
		return ItemBase:GetIcon(callbackFunc);
	end
end

-- When this item is clicked
function Exe_AppCommand:OnClick(mouseButton)
	if(self.AppCommand) then
		Map3DSystem.App.Commands.Call(self.AppCommand, self.params);
	end	
end

-- Get the tooltip of this object
-- @param callbackFunc: function (text) end. if nil, it will return the text. otherwise it will use the callback,since the icon may not be immediately available at call time.  
function Exe_AppCommand:GetTooltip(callbackFunc)
	if(self.tooltip) then
		return self.tooltip;
	elseif(self.AppCommand or self.cmd) then
		
		self.cmd = self.cmd or Map3DSystem.App.Commands.GetCommand(self.AppCommand)
		if(self.cmd) then
			self.tooltip = self.cmd.ButtonText or self.cmd.tooltip;
			return self.tooltip;
		end	
	else
		return ItemBase:GetTooltip(callbackFunc);
	end
end