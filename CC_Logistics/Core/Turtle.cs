namespace CC_Logistics;
using Newtonsoft.Json;

public class Turtle : Computer
{
    public override async Task Init()
    {
        await base.Init();
        Console.WriteLine("Turtle initialized.");
        await Craft();
    }
    public async Task Craft()
    {
        Console.WriteLine("Crafting.");
        Dictionary<string, int> val = new() {
            { "minecraft:oak_log", 1}
        };
        await Network.Socket.Send($"OnCraftRequested({JsonConvert.SerializeObject(val)}, 1)");
        //await Network.Socket.Send("WS.send(textutils.serialiseJSON({ Data = { ID = os.getComputerID(), Label = os.getComputerLabel() } }))");
    }
}
