Version = "1.0.0"

----- #region DOCS -----
-- Items can only be dispensed at turtles.
-- TODO: Recipes
-- TODO: Chest skill fix
-- Maybe parent.h - 1 or something could fix stuff? probably yeah because i bet it's just an int
----- #endregion /DOCS -----

----- #region VARIABLES -----
Color_Primary = colors.purple
Color_Secondary = colors.magenta
Color_Tertiary = colors.pink
Color_Text = colors.white

Selected_Resource = nil

Request = {
	Execute = 1,
    Dispense_Items = 2
}
Sound = {
    Connect = 1,
    Disconnect = 2
}
Side_Types = {
    top = peripheral.getType("top"),
    left = peripheral.getType("left"),
    right = peripheral.getType("right"),
    bottom = peripheral.getType("bottom"),
    front = peripheral.getType("front"),
    back = peripheral.getType("back")
}
-- [item_name] count
Reserved_Items = {

}
----- #endregion /VARIABLES -----

----- #region GENERAL METHODS -----
function GetConnectedDevices()
    return peripheral.getNames()
end
function GetConnectedInventories()
    return {peripheral.find("inventory")}
end
function GetConnectedComputers()
    return {peripheral.find("computer")}
end
function GetConnectedTurtles()
    return {peripheral.find("turtle")}
end
function GetNetworkedComputers()
    return {rednet.lookup("CC_Logistics")}
end
function GetNetworkedClients()
    return {rednet.lookup("CC_Logistics_Client")}
end
function GetNetworkedHost()
    return rednet.lookup("CC_Logistics_Host")
end
function GetIsTurtle()
    return turle ~= nil
end
function GetIsHostNode()
	return rednet.lookup("CC_Logistics_Host") == os.getComputerID()
end
function TablesAreEqual(t1, t2)
    local keys = {}
    for k in pairs(t1) do
        table.insert(keys, k)
    end
    table.sort(keys)

    for i, k in ipairs(keys) do
        if t1[k] ~= t2[k] then
            return false
        end
    end
    return true
end

function Console_Log(message)
end
function PlaySound(sound)
    for i, speaker in pairs({peripheral.find("speaker")}) do
        if (sound == Sound.Connect) then
            speaker.playNote("flute", 1.0, 18)
            sleep(0.25)
            speaker.playNote("flute", 1.0, 8)
            sleep(0.12)
            speaker.playNote("flute", 1.0, 8)
            sleep(0.1)
            speaker.playNote("flute", 1.0, 12)
        elseif (sound == Sound.Disconnect) then
            speaker.playNote("flute", 1.0, 6)
            sleep(0.1)
            speaker.playNote("flute", 1.0, 4)
            sleep(0.12)
            speaker.playNote("flute", 1.0, 2)
        end
    end
end
function Alternate_Color(iteration)
    if iteration % 2 == 0 then
        return Color_Secondary
    else
        return Color_Tertiary
    end
end
function DiscardNamespaceSort(arg1, arg2)
    return string.sub(arg1, string.find(arg1, ":") + 1, -1) < string.sub(arg2, string.find(arg2, ":") + 1, -1)
end
function PairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
      i = i + 1
      if a[i] == nil then return nil
      else return a[i], t[a[i]]
      end
    end
    return iter
end
function TryParseSide(side)
    local ret = peripheral.getType(side)
    if ret == nil then
        return side
    else
        return ret
    end
end
function ResolveNameFromSide(side) -- convert "top" to "minecraft:chest_19" somehow
    peripheral.getNames() -- doesn't seem like there's a good way of doing this so we'll grab a random item and shove it in the last slot then test which one has only that item in that slot then map it
end

function Request_Execute(data, target)
    local message = {
        sender = {name = os.getComputerLabel(), id = os.getComputerID()},
        request = {header = Request.Execute, body = {data = data, target = target}}
    }
    rednet.broadcast(message)
end
function Request_Dispense_Items(item, quantity, target)
    local message = {
        sender = {name = os.getComputerLabel(), id = os.getComputerID()},
        request = {header = Request.Dispense_Items, body = {item = item, quantity = quantity, target = target}}
    }
    rednet.broadcast(message)
end
function Dispense_Items(item_name, item_quantity)
    if (turtle == nil) then
        return 0
    end
    if (type(item_name) ~= "string") then
        Basalt.debug("item_name: " .. type(item_name))
        return 0
    end
    if (type(item_quantity) ~= "number") then
        Basalt.debug("item_quantity: " .. type(item_quantity))
        return 0
    end

    local tempChest
    local tempChestSide
    local drawer
    for side, side_type in pairs(Side_Types) do
        if (side_type == "minecraft:chest") then
            tempChest = peripheral.wrap(side)
            tempChestSide = side
        elseif (side_type == "storagedrawers:controllers") then
            drawer = peripheral.wrap(side)
        end
    end

    local transferredItems = 0
    for _, inventory in pairs(GetConnectedInventories()) do
        for slot, item in pairs(inventory.list()) do
            if (item.name == item_name) then
                Basalt.debug(peripheral.getName(tempChest))
                transferredItems = transferredItems + inventory.pushItems(peripheral.getName(tempChest), slot, item_quantity - transferredItems) -- Bugged. Side_Types doesn't exist?
            end
            if (transferredItems >= item_quantity) then
                goto finish
            end
        end
    end

    ::finish::
    turtle.select(1)
    if (tempChestSide == "front") then
        turtle.suck(item_count)
    elseif (tempChestSide == "top") then
        turtle.suckUp(item_count)
    elseif (tempChestSide == "bottom") then
        turtle.suckDown(item_count)
    elseif (tempChestSide == "left") then
        turtle.turnLeft()
        turtle.suck(item_count)
        turtle.turnRight()
    elseif (tempChestSide == "right") then
        turtle.turnRight()
        turtle.suck(item_count)
        turtle.turnLeft()
    elseif (tempChestSide == "back") then
        turtle.turnRight()
        turtle.turnRight()
        turtle.suck(item_count)
        turtle.turnLeft()
        turtle.turnLeft()
    end
    for i = 1, 16 do
        turtle.select(i)
        if (turtle.getItemCount(i) == 0) then
            break
        end
        turtle.drop()
    end
    turtle.select(1)
    Resource_Menu.Refresh(Resource_Menu.ResourceScrollableSearch:getValue())
    return transferredItems
end
function GetAllItemsInConnectedInventories()
    local items = {}

    for _, inventory in pairs(GetConnectedInventories()) do
        for slot, item in pairs(inventory.list()) do
            if (items[item.name] ~= nil) then
                items[item.name] = items[item.name] + item.count
            else
                items[item.name] = item.count
            end
        end
    end

    return items
end
----- #endregion /GENERAL METHODS -----

----- #region EVENTS -----
function OnPeripheralAddedOrRemoved()
    while true do
        parallel.waitForAny(
            function()
                local event, side = os.pullEvent("peripheral")
                Network_Menu.Refresh()
                PlaySound(Sound.Connect)
            end,
            function()
                local event, side = os.pullEvent("peripheral_detach")
                Network_Menu.Refresh()
                PlaySound(Sound.Disconnect)
            end
        )
    end
end
function OnCheckHostAlive()
	while true do
		if (GetNetworkedHost() == nil) then
			PromoteToHost()
		end
		sleep(30)
	end
end
function OnRednetReceive()
    while true do
        local id, message = rednet.receive()
		if (message ~= nil and message.request ~= nil) then
			if (message.request.body.target ~= os.getComputerID() and message.request.body.target ~= -1) then
				return
			end
			if (message.request.header ~= nil and message.request.header == Request.Execute) then
				pcall(load(message.request.body.data, nil, "t", _ENV))
			end
		else
			if (message ~= nil and (type(message) == "string" or type(message) == "function")) then
				pcall(load(message, nil, "t", _ENV))
			end
		end

        --if (turtle ~= nil) then
        --    if (message.request.header == Request.Dispense_Items) then
        --        Dispense_Items(message.request.body.item, message.request.body.quantity)
        --    end
        --end
    end
end
function OnWSReceive()
	WS = http.websocket("ws://toxic-cookie.duckdns.org:8080/")
	--pcall(function() WS.send(textutils.serialiseJSON({ Data = { ID = os.getComputerID(), Label = os.getComputerLabel() } })) end)
    while true do
		WS_Message = nil
		if (not pcall(function() WS_Message = WS.receive() end)) then
			pcall(function() WS.close() end)
			WS = http.websocket("ws://toxic-cookie.duckdns.org:8080/")
			--pcall(function() WS.send(textutils.serialiseJSON({ Data = { ID = os.getComputerID(), Label = os.getComputerLabel() } })) end)
		end
		if (WS_Message ~= nil) then
			if (not pcall(load(WS_Message, nil, "t", _ENV))) then
			end
		end
    end
end
function OnCraftRequested(ingredientPattern, amountToCraft)
	local remap = {1, 2, 3, 5, 6, 7, 9, 10, 11}

	local assignedCacheStorage
    for _, inventory in pairs(GetConnectedInventories()) do
		if (inventory.size() > 26 and peripheral.getName(inventory) ~= "front" and peripheral.getName(inventory) ~= "top") then
			local lastItem = inventory.getItemDetail(27)
			if (lastItem ~= nil and tonumber(lastItem.displayName) == os.getComputerID()) then
				assignedCacheStorage = inventory
				break
			end
		end
    end

	for pattern_slot, item_name in pairs(ingredientPattern) do
		pattern_slot = tonumber(pattern_slot)
		local transferredItems = 0
    	for _, inventory in pairs(GetConnectedInventories()) do
			if (peripheral.getName(inventory) ~= "front" and peripheral.getName(inventory) ~= "top") then
				for slot, item in pairs(inventory.list()) do
					if (item.name == item_name) then
						transferredItems = transferredItems + assignedCacheStorage.pullItems(peripheral.getName(inventory), slot, amountToCraft - transferredItems)
					end
					if (transferredItems >= amountToCraft) then
						turtle.select(remap[pattern_slot])
						turtle.suckUp(amountToCraft)
						goto next_pattern_slot
					end
				end
			end
    	end
		::next_pattern_slot::
	end

	turtle.craft()
	for i = 1, 16 do
		turtle.select(i)
		turtle.drop()
	end
end

----- #endregion /EVENTS -----

----- #region INIT -----
Craft_Menu = {
    Init = function ()
    Menus.Craft:addLabel()
        :setText("Craft Menu")
        :setPosition(2, 2)
    end,
    Refresh = function ()
        
    end
}
Network_Menu = {
    NetworkScrollable = nil,
    Init = function()
        Network_Menu.NetworkScrollable = Menus.Network:addScrollableFrame()
        :setBackground(Color_Tertiary)
        :setSize("parent.w * 0.96", "parent.h * 0.8")
        :setPosition(2, 2)
    end,
    Refresh = function()
        Network_Menu.NetworkScrollable:removeChildren()
        local i = 1
        for _, device in PairsByKeys(peripheral.getNames()) do
            Network_Menu.NetworkScrollable:addLabel()
                :setPosition(1, i)
                :setSize("parent.w", 1)
                :setBackground(Alternate_Color(i))
                :setForeground(Color_Text)
                :setText(TryParseSide(device))
            i = i + 1
        end
    end
}
Resource_Menu = {
    ResourceScrollable = nil,
    ResourceScrollableSearch = nil,
    Init = function ()
        Resource_Menu.ResourceScrollableSearch = Menus.Resources:addInput()
        :setBackground(Color_Secondary)
        :setForeground(Color_Text)
        :setPosition(2,2)
        :setSize("parent.w * 0.96", 1)
        :setInputType("text")
        :setDefaultText("search...")
        :setInputLimit(128)
        --:onChange(function ()
        --    Resource_Menu.Refresh(Resource_Menu.ResourceScrollableSearch:getValue())
        --end)
        :onLoseFocus(function ()
            Resource_Menu.Refresh(Resource_Menu.ResourceScrollableSearch:getValue())
        end)
        Resource_Menu.ResourceScrollable = Menus.Resources:addScrollableFrame()
            :setBackground(Color_Tertiary)
            :setSize("parent.w * 0.96", "parent.h * 0.65")
            :setPosition(2, 4)

        if (turtle == nil) then
            return
        end
        local resourceActionsFlex = Menus.Resources:addFlexbox()
            :setPosition(2, 3)
            :setSpacing(0)
            :setBackground(colors.orange)
            :setSize("parent.w * 0.96", 1)
        resourceActionsFlex:addButton()
            :setText("x1")
            :setSize("parent.w * 0.33", "parent.h")
            :setBackground(colors.lime)
            :setForeground(colors.white)
            :onClick(function(self,event,button,x,y)
                if(event=="mouse_click")and(button==1) then
                    Dispense_Items(Selected_Resource, 1)
                end
            end)
        resourceActionsFlex:addButton()
            :setText("x8")
            :setSize("parent.w * 0.34", "parent.h")
            :setBackground(colors.lime)
            :setForeground(colors.white)
            :onClick(function(self,event,button,x,y)
                if(event=="mouse_click")and(button==1) then
                    Dispense_Items(Selected_Resource, 8)
                end
            end)
        resourceActionsFlex:addButton()
            :setText("x64")
            :setSize("parent.w * 0.33", "parent.h")
            :setBackground(colors.lime)
            :setForeground(colors.white)
            :onClick(function(self,event,button,x,y)
                if(event=="mouse_click")and(button==1) then
                    Dispense_Items(Selected_Resource, 64)
                end
            end)
    end,
    Refresh = function (filter)
        Resource_Menu.ResourceScrollable:removeChildren()
        local i = 1
        if filter == nil then
            for item_name, item_count in pairs(GetAllItemsInConnectedInventories(), DiscardNamespaceSort) do
                --local nice_name = string.sub(item_name, string.find(item_name, ":") + 1, -1)
                Resource_Menu.ResourceScrollable:addButton()
                    :setPosition(1, i)
                    :setSize("parent.w", 1)
                    :setBackground(Alternate_Color(i))
                    :setForeground(Color_Text)
                    :setText(("%dx %s"):format(item_count, item_name))
                    :onClick(function(self,event,button,x,y)
                        if(event=="mouse_click")and(button==1)then
                            Selected_Resource = item_name
                        end
                    end)
                i = i + 1
            end
        else
            for item_name, item_count in PairsByKeys(GetAllItemsInConnectedInventories(), DiscardNamespaceSort) do
                if string.find(item_name, string.lower(filter)) ~= nil then
                    --local nice_name = string.sub(item_name, string.find(item_name, ":") + 1, -1)
                    Resource_Menu.ResourceScrollable:addButton()
                        :setPosition(1, i)
                        :setSize("parent.w", 1)
                        :setBackground(Alternate_Color(i))
                        :setForeground(Color_Text)
                        :setText(("%dx %s"):format(item_count, item_name))
                        :onClick(function(self,event,button,x,y)
                            if(event=="mouse_click")and(button==1)then
                                Selected_Resource = item_name
                            end
                        end)
                    i = i + 1
                end
            end
        end
    end
}
Recipe_Menu = {
    Init = function ()
        
    end,
    Refresh = function ()
        
    end
}
Console_Menu = {
    Init = function ()
    Menus.Console:addLabel()
        :setText("Console Menu")
        :setPosition(2, 2)
    end,
    Refresh = function ()
        
    end
}

function OpenMenu(menu_name)
    for k,v in pairs(Menus) do
        if (menu_name ~= k) then
            v:hide()
        else
            v:show()
        end
    end
end
function Init()
    Basalt = require("basalt")
    GUI = Basalt.createFrame():setTheme({FrameBG = Color_Primary, FrameFG = Color_Secondary})

    Menus = {
        Craft = GUI:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"),
        Network = GUI:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
        Resources = GUI:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
        Recipes = GUI:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
        Console = GUI:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide()
    }

    Menubar = GUI:addMenubar()
        :setBackground(Color_Secondary)
        :setForeground(Color_Text)
        :setSelectionColor(Color_Primary)
        :setScrollable()
        :setSize("parent.w")
        :onChange(function(self, val)
            OpenMenu(Menubar:getItem(self:getItemIndex()).text)
        end)
        :addItem("Craft")
        :addItem("Network")
        :addItem("Resources")
        :addItem("Recipes")
        :addItem("Console")

    Craft_Menu.Init()
    Craft_Menu.Refresh()
    Network_Menu.Init()
    Network_Menu.Refresh()
    Resource_Menu.Init()
    Recipe_Menu.Init()
    Console_Menu.Init()
    Console_Menu.Refresh()

	GUI:addProgram()
        :execute(OnPeripheralAddedOrRemoved)
        :hide()
    Init_Networking()

    Basalt.autoUpdate()
end
function PromoteToHost()
	rednet.unhost("CC_Logistics_Client")
	rednet.host("CC_Logistics_Host", os.getComputerLabel())
	Init_WS()
end
function Init_Networking()
    Modem = peripheral.find("modem", rednet.open)
	if (GetNetworkedHost() == nil) then
		rednet.host("CC_Logistics_Host", os.getComputerLabel())
		Init_WS()
	else
		rednet.host("CC_Logistics_Client", os.getComputerLabel())
		GUI:addProgram()
			:execute(OnCheckHostAlive)
			:hide()
	end
	GUI:addProgram()
		:execute(OnRednetReceive)
		:hide()

	--for i, computerID in PairsByKeys(GetNetworkedComputers()) do
	--end
end
function Init_WS()
	GUI:addProgram()
        :execute(OnWSReceive)
        :hide()
end
----- #endregion /INIT -----

Init()