local Version = "1.0.0"

function Download(url, file)
	local content = http.get(url).readAll()
	if (not content) then
		error("Could not connect to website")
	end
	local f = fs.open(file, "w+")
	f.write(content)
	f.close()
end

if (not fs.exists("basalt.lua")) then
	shell.run("wget run https://basalt.madefor.cc/install.lua release latest.lua")
end

pcall(shell.run("delete startup.lua"))
--shell.run("wget https://raw.githubusercontent.com/Toxic-Cookie/CC_Logistics/master/CC_Logistics/Core/Lua/startup.lua startup.lua")
Download("https://raw.githubusercontent.com/Toxic-Cookie/CC_Logistics/master/CC_Logistics/Core/Lua/startup.lua", "startup.lua")

pcall(shell.run("delete CC_Logistics.lua"))
--shell.run("wget https://raw.githubusercontent.com/Toxic-Cookie/CC_Logistics/master/CC_Logistics/Core/Lua/CC_Logistics.lua CC_Logistics.lua")
Download("https://raw.githubusercontent.com/Toxic-Cookie/CC_Logistics/master/CC_Logistics/Core/Lua/CC_Logistics.lua", "CC_Logistics.lua")

shell.run("CC_Logistics.lua")