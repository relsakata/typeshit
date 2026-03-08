local file = file~=nil and file or "script" --script, test, rewrite
local forceOn = forceOn~=nil and forceOn or {
    vars = {
        remote = true,
        digmethod = "Remote"
    },
    misc = {
        bedel2 = true
    },
    toys = {
        hiddenstickers = true,
        discardstickers = true
    }
}

local HttpService = game:GetService("HttpService")
local autoload = `atlas-{game.Players.LocalPlayer.Name}.json`
local configlocation = isfile(autoload) and `atlas/{autoload}` or `atlas/Preset 1.json`

xpcall(loadstring(game:HttpGet(`https://raw.githubusercontent.com/Chris12089/atlasbss/main/{file}.lua`)), game.Players.LocalPlayer.Kick, "atlas error")

local MergeTable

MergeTable = function(reference, atlas)
    for i, v in reference do
        if typeof(v) == "table" then
            return MergeTable(v, atlas[i])
        end
        if typeof(atlas) ~= "number" then
            atlas[i] = v
        end
        return
    end
end

task.spawn(function()
	local tries=0
	while task.wait(1) do
        for _, ConfigTable in filtergc("table", {Keys={"vars"}}, false) do
            for i, v in forceOn do
                MergeTable(forceOn, ConfigTable)
            end
        end

		if tries>=10 then
			game.Players.LocalPlayer:Kick('some shit broke idk rejoin')
		end
	end
end)
