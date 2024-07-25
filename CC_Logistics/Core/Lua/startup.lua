local Version = "1.0.0"

if (not fs.exists("basalt.lua")) then
	shell.run("wget run https://basalt.madefor.cc/install.lua release latest.lua")
end
if (fs.exists("startup.lua")) then
	shell.run("delete startup.lua")
end
shell.run("wget https://raw.githubusercontent.com/Toxic-Cookie/CC_Logistics/master/CC_Logistics/Core/Lua/startup.lua startup.lua")
if (fs.exists("CC_Logistics.lua")) then
	shell.run("delete CC_Logistics.lua")
end
shell.run("wget https://raw.githubusercontent.com/Toxic-Cookie/CC_Logistics/master/CC_Logistics/Core/Lua/CC_Logistics.lua CC_Logistics.lua")

shell.run("CC_Logistics.lua")