

local MonsterHandBook = commonlib.gettable("MyCompany.Aries.Debug.MonsterHandBook");

function MonsterHandBook.init()
	MonsterHandBook.monsterListTable = {};
    local monstXML = ParaXML.LuaXML_ParseFile("config/Aries/Others/monsterinformations.xml");
    local worldnode;
    for worldnode in commonlib.XPath.eachNode(monstXML,"/worlds/world") do
        local monsternode;
		local worldname = worldnode.attr.name;
		if(not MonsterHandBook.monsterListTable[worldname]) then
			MonsterHandBook.monsterListTable[worldname] = {};
		end
        for monsternode in commonlib.XPath.eachNode(worldnode,"/monster") do
            if(monsternode.attr) then
				table.insert(MonsterHandBook.monsterListTable[worldname],monsternode.attr);
            end
        end
    end
	echo(MonsterHandBook.monsterListTable);
end

function MonsterHandBook.ShowPage()
	local params = {
		url = "script/apps/Aries/Debug/MonsterHandBook.html",
		name = "MonsterHandBook.ShowPage", 
		app_key=MyCompany.Aries.app.app_key, 
		isShowTitleBar = false,
		DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
		enable_esc_key = true,
		style = CommonCtrl.WindowFrame.ContainerStyle,
		allowDrag = true,
		-- zorder = 0,
		directPosition = true,
			align = "_ct",
			x = -800/2,
			y = -500/2,
			width = 800,
			height = 500,
	};
	System.App.Commands.Call("File.MCMLWindowFrame", params);	
end