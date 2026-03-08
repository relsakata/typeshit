local forceOn = forceOn~=nil and forceOn or {}

function MergeTable(reference, atlas)
    for i, v in reference do
        if typeof(v) == "table" then
            atlas[i] = MergeTable(v, atlas[i])
        end
        if typeof(atlas) ~= "number" and typeof(v) ~= "table" then
            atlas[i] = v
            warn(`Key: {i}\nValue: {v}`)
        end
    end
    return atlas
end

function checkConfigWrong(tab)
    for key, value  in forceOn do
        if typeof(value) == "table" then
            for i, v in value do
                if tab[key][i]~=v then
                    return true
                end
            end
        elseif typeof(value) ~= "table" then
            if tab[key] ~= value then
                return true
            end
        end
        return false
    end
end

task.spawn(function()
	local tries=0
	while task.wait(10) do
        for _, ConfigTable in filtergc("table", {Keys={"vars"}}, false) do
            if ConfigTable~=forceOn and typeof(ConfigTable["vars"]) == "table" and ConfigTable["vars"]["remote"]~=true then
                tries+=1
                ConfigTable["vars"]["remote"] = true
                ConfigTable["vars"]["digmethod"] = "Remote"
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
