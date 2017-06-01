--[[
Title: code behind for page GenerateAssetReplaceFile.html
Author(s): WangTian
Date: 2009/4/24
Desc:  script/apps/Aries/Debug/GenerateAssetReplaceFile.html
Use Lib:
-------------------------------------------------------
-------------------------------------------------------
]]
MyCompany.Debug = MyCompany.Debug or {};
local GenerateAssetReplaceFile = {};
commonlib.setfield("MyCompany.Debug.GenerateAssetReplaceFile", GenerateAssetReplaceFile);

-- The data source for items
function GenerateAssetReplaceFile.OnClickGenerate(initdirs, filters, postfix)
	
    local replacefiles_writeline = {};
    
    local _, initdir;
    for _, initdir in ipairs(initdirs) do
		local files = {};
		commonlib.SearchFiles(files, initdir, filters, 25, 100000, true);
	    
		local _, filename;
		for _, filename in ipairs(files) do
			local originalfile, ext = string.match(filename, "^(.+)"..postfix..".(.+)$");
			if(originalfile and ext) then
				local replacefile = initdir..originalfile..postfix.."."..ext;
				originalfile = initdir..originalfile.."."..ext;
				if(ParaIO.DoesFileExist(originalfile) == true) then
					table.insert(replacefiles_writeline, originalfile..","..replacefile);
				end
			end
			-- test the _32bits png texture
			local originalfile, ext = string.match(filename, "^(.+)"..postfix.."_32bits.(.+)$");
			if(originalfile and ext) then
				if(ext == "png") then
					local replacefile = initdir..originalfile..postfix.."_32bits."..ext;
					originalfile = initdir..originalfile.."_32bits."..ext;
					if(ParaIO.DoesFileExist(originalfile) == true) then
						table.insert(replacefiles_writeline, originalfile..","..replacefile);
					end
				end
			end
		end
    end
    
    commonlib.echo(replacefiles_writeline);
    
    ParaIO.DeleteFile("AssetsReplaceFile.txt");
    
	local file = ParaIO.open("AssetsReplaceFile.txt", "w");
	if(file:IsValid() == true) then
		file:WriteString([[-- ParaEngine will replace left with right for both disk and asset files, ]].."\n");
		file:WriteString([[-- after ParaIO.LoadReplaceFile("AssetsReplaceFile.txt", false);]].."\n");

		local _, writeline;
		for _, writeline in ipairs(replacefiles_writeline) do
			file:WriteString(writeline.."\n");
		end
		file:close();
	end
    
	--local files = {};
    --commonlib.SearchFiles(files, "texture/", {"*.dds"}, 20, 100000, true);
    --commonlib.echo(files);
end


---- count polys
--function GenerateAssetReplaceFile.OnClickGenerate(initdirs, filters, postfix)
	--
	--local root = "texture/";
	--
	------ public world
	----NPL.load("(gl)script/ide/AssetPreloader.lua");
	----local loader = commonlib.AssetPreloader:new({
		----callbackFunc = function(nItemsLeft, loader)
			----log(nItemsLeft.." assets remaining\n")
			----if(nItemsLeft <= 19) then
				----if(dj == true) then
					----return;
				----end
				----dj = true;
				----local poly_count = 0;
				----local tex_count = 0;
				----local all_x = commonlib.Files.Find({}, root, 20, 100000, "*.x")
				----local i, file;
				----for i, file in pairs(all_x) do
					----local y = string.match(file.writedate,"%d+")
					----local m = string.match(file.writedate,"%-(%d+)")
					----if(tonumber(y) >= 2009 and tonumber(m)>= 4) then
						----local entity = ParaAsset.LoadParaX("", root..file.filename);
						----if(entity and entity:IsValid() == true) then
							----local att = entity:GetAttributeObject();
							----commonlib.echo(root..file.filename)
							----commonlib.echo(file.writedate);
							----local TextureUsage = att:GetField("TextureUsage", "");
							----local texture_usage = string.match(TextureUsage, "^cnt:(%d+);(.+)")
							----commonlib.echo(texture_usage);
							----commonlib.echo(att:GetField("PolyCount", 0))
							----local poly_usage = att:GetField("PolyCount", 0);
							----if(poly_usage and poly_usage > 0) then
								----poly_count = poly_count + poly_usage;
							----end
							----if(texture_usage) then
								----tex_count = tex_count + tonumber(texture_usage);
							----end
						----end
					----end
				----end
				----
				----log("============ poly count: ============\n")
				----commonlib.echo(poly_count)
				----log("============ texture count: ============\n")
				----commonlib.echo(tex_count)
			----end
		----end
	----});
	--
	--local count = 0;
	--local all_x = commonlib.Files.Find({}, root, 20, 100000, "*.png")
	--local i, file;
	--for i, file in pairs(all_x) do
		--local y = string.match(file.writedate,"%d+")
		--local m = string.match(file.writedate,"%-(%d+)")
		--if(tonumber(y) >= 2009 and tonumber(m)>= 4) then
			--count = count + 1;
		--end
	--end
	--log("============ png count: ============\n")
	--commonlib.echo(count)
--end
