local file = "script" --script, test, rewrite
local ConfigJSON 
local HttpService = game:GetService("HttpService")
local reExecute = false
local configlocation = `atlas/{readfile(`atlas-{game.Players.LocalPlayer.Name}.json`)}`
local oldclonefunction
oldclonefunction = hookfunction(clonefunction, newcclosure(function(...)
	local args = {...}
	if args[1] == writefile or args[1] == readfile then
		return args[1]
	end
	
	return oldclonefunction(...)
end))
local oldreadfile
oldreadfile = hookfunction(readfile, newcclosure(function(...)
	local args = {...}
	if args[1] == configlocation then
		ConfigJSON = oldreadfile(configlocation)
		local ConfigTable = HttpService:JSONDecode(ConfigJSON)
		if not ConfigTable["vars"]["remote"] then ConfigTable["vars"]["remote"] = true end
		if ConfigTable["vars"]["digmethod"]~="Remote" then ConfigTable["vars"]["digmethod"] = "Remote" end
		if not ConfigTable["misc"]["bqdel2"] then ConfigTable["misc"]["bqdel2"] = true end
		if not ConfigTable["toys"]["hiddenstickers"] then ConfigTable["toys"]["hiddenstickers"] = true end
		if not ConfigTable["toys"]["discardstickers"] then ConfigTable["toys"]["discardstickers"] = true end
		writefile(HttpService:JSONEncode(ConfigTable))
		reExecute=true
		return HttpService:JSONEncode(ConfigTable)
	end
	return oldreadfile(...)
end))
local oldwritefile
oldwritefile = hookfunction(writefile, newcclosure(function(...)
	local args = {...}
	if args[1] == configlocation then
		local ConfigTable = HttpService:JSONDecode(args[2])
		if not ConfigTable["vars"]["remote"] then
			reExecute = true
			return
		end
	end
	return oldwritefile(...)
end))

task.spawn(function()
	while task.wait(10) do
		if reExecute then
			game.Players.LocalPlayer:Kick()
			reExecute = false
		end
	end
end)

local succ, err = pcall(loadstring(game:HttpGet(`https://raw.githubusercontent.com/Chris12089/atlasbss/main/{file}.lua`)))
if not succ then
	game.Players.LocalPlayer:Kick("atlas error lmao")
end
