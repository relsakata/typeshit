local file = "script" --script, test, rewrite
local HttpService = game:GetService("HttpService")
local configlocation = isfile(`atlas-{game.Players.LocalPlayer.Name}.json`) and `atlas/{readfile(`atlas-{game.Players.LocalPlayer.Name}.json`)}` or `atlas/Preset 1.json`

local tries=0

local succ, err = pcall(loadstring(game:HttpGet(`https://raw.githubusercontent.com/Chris12089/atlasbss/main/{file}.lua`)))
if not succ then
	game.Players.LocalPlayer:Kick("atlas error lmao")
end

task.spawn(function()
	while task.wait(1) do
        for i, ConfigTable in filtergc("table", {Keys={"vars"}}, false) do
            if ConfigTable then
                if not ConfigTable["vars"]["remote"] then tries+=1 warn('remote off') ConfigTable["vars"]["remote"] = true end
                if ConfigTable["vars"]["digmethod"]~="Remote" then ConfigTable["vars"]["digmethod"] = "Remote" end
                if not ConfigTable["misc"]["bqdel2"] then ConfigTable["misc"]["bqdel2"] = true end
                if not ConfigTable["toys"]["hiddenstickers"] then ConfigTable["toys"]["hiddenstickers"] = true end
                if not ConfigTable["toys"]["discardstickers"] then ConfigTable["toys"]["discardstickers"] = true end

                writefile(configlocation, HttpService:JSONEncode(ConfigTable)) -- save just incase
            end
        end

		if tries>=10 then
			game.Players.LocalPlayer:Kick('some shit broke idk rejoin')
		end
	end
end)
