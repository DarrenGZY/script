--[[
Title: SmelterPage
Author(s): LiXizhi
Date: 2014/1/7
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Creator/Game/GUI/SmelterPage.lua");
local SmelterPage = commonlib.gettable("MyCompany.Aries.Game.GUI.SmelterPage");
SmelterPage.ShowPage(entity);
-------------------------------------------------------
]]
local block_types = commonlib.gettable("MyCompany.Aries.Game.block_types")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager");

local SmelterPage = commonlib.gettable("MyCompany.Aries.Game.GUI.SmelterPage");

SmelterPage.firing = nil;

local cur_entity;
local page;

function SmelterPage.OnInit()
	page = document:GetPageCtrl();
end

function SmelterPage.GetEntity()
	return cur_entity;
end

function SmelterPage.GetContainerView()
	if(cur_entity) then
		return cur_entity.inventoryView;
	end
end

function SmelterPage.GetItemID()
	if(cur_entity) then
		return cur_entity:GetBlockId();
	else
		return 0;
	end
end

function SmelterPage.GetItemName()
    local block = block_types.get(SmelterPage.GetItemID())
    if(block) then
        return block:GetDisplayName();
    end
end

function SmelterPage.GetCommand()
	if(cur_entity) then
		return cur_entity:GetCommand();
	end
end

function SmelterPage.ShowPage(entity, OnClose)
	if(not entity) then
		return;
	end
	cur_entity = entity;
	local params = {
			url = "script/apps/Aries/Creator/Game/GUI/SmelterPage.html", 
			name = "SmelterPage.ShowPage", 
			isShowTitleBar = false,
			DestroyOnClose = true,
			bToggleShowHide=false, 
			style = CommonCtrl.WindowFrame.ContainerStyle,
			allowDrag = false,
			enable_esc_key = true,
			bShow = true,
			click_through = false, 
			zorder = -1,
			app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
			directPosition = true,
				align = "_ct",
				x = -210,
				y = -190,
				width = 420,
				height = 380,
		};
	System.App.Commands.Call("File.MCMLWindowFrame", params);
	params._page.OnClose = OnClose;
end
