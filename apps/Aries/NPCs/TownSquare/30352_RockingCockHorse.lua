--[[
Title: RockingCockHorse
Author(s): Leio
Date: 2010/02/01

use the lib:

------------------------------------------------------------
script/apps/Aries/NPCs/TownSquare/30352_RockingCockHorse.lua
------------------------------------------------------------
]]

-- create class
local libName = "RockingCockHorse";
local RockingCockHorse = {};
commonlib.setfield("MyCompany.Aries.Quest.NPCs.RockingCockHorse", RockingCockHorse);

local Quest = MyCompany.Aries.Quest;
local GameObject = MyCompany.Aries.Quest.GameObject;
local NPC = MyCompany.Aries.Quest.NPC;

local ItemManager = System.Item.ItemManager;
local hasGSItem = ItemManager.IfOwnGSItem;
local equipGSItem = ItemManager.IfEquipGSItem;

-- RockingCockHorse.main
function RockingCockHorse.main()
end
function RockingCockHorse.PreDialog(npc_id, instance)
	_guihelper.Custom_MessageBox("<div style='margin-left:15px;margin-top:25px;text-align:center'>我是晃晃木马，2片红枫叶就可以带我回家哦，你确认要带我回家吗？</div>",function(result)
		if(result == _guihelper.DialogResult.Yes)then
			RockingCockHorse.DoExchange()
		else
			
		end
	end,_guihelper.MessageBoxButtons.YesNo,{yes = "Texture/Aries/Common/OK_32bits.png; 0 0 153 49", no = "Texture/Aries/Common/Cancel_32bits.png; 0 0 153 49"});
	return false;
end
function RockingCockHorse.DoExchange()
	local __,__,__,copies = hasGSItem(17077);
	copies = copies or 0;
	if(copies < 2)then
		_guihelper.Custom_MessageBox("<div style='margin-left:15px;margin-top:25px;text-align:center'>你的红枫叶还不够哦，再多去其他哈奇家找找挑战之旗吧！</div>",function(result)
			if(result == _guihelper.DialogResult.OK)then
				commonlib.echo("OK");
			end
		end,_guihelper.MessageBoxButtons.OK,{ok = "Texture/Aries/Common/IKnow_32bits.png; 0 0 153 49"});
	else
		ItemManager.ExtendedCost(291, nil, nil, function(msg)end, function(msg)
				commonlib.echo("======Get_30101_RockingCockHorse return");
				commonlib.echo(msg);
				if(msg.issuccess) then
				
				end
		end)
	end
end
