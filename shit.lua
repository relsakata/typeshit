local file = file~=nil and file or "script" --script, test, rewrite
local forceOn = forceOn~=nil and forceOn or {
    vars = {
        remote = true,
        digmethod = "Remote"
    }
}

local HttpService = game:GetService("HttpService")
local autoload = `atlas-{game.Players.LocalPlayer.Name}.json`
local configlocation = isfile(autoload) and `atlas/{autoload}` or `atlas/Preset 1.json`

local succ, err = pcall(loadstring(game:HttpGet(`https://raw.githubusercontent.com/Chris12089/atlasbss/main/{file}.lua`)))
if not succ then
    game.Players.LocalPlayer:Kick(err)
end

function MergeTable(reference, atlas)
    for i, v in reference do
        warn(`Key: {i}\nValue: {v}`)
        if typeof(v) == "table" then
            atlas[i] = MergeTable(v, atlas[i])
        end
        if typeof(atlas) ~= "number" then
            atlas[i] = v
        end
    end
    return atlas
end

task.spawn(function()
	local tries=0
	while task.wait(1) do
        for _, ConfigTable in filtergc("table", {Keys={"vars"}}, false) do
            if typeof(ConfigTable["vars"]) == "table" and ConfigTable["vars"]["remote"] == false then
                tries+=1
                for i, v in forceOn do
                    MergeTable(forceOn, ConfigTable)
                end
            end
        end

		if tries>=10 then
			game.Players.LocalPlayer:Kick('some shit broke idk rejoin')
		end
	end
end)
