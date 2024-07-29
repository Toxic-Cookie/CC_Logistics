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
        Dictionary<int, string> val = new() {
            { 1, "minecraft:oak_log" }
        };
        //List<int, string> val2 = new() {
        //    { 1, "minecraft:oak_log" },
        //    { 4, "minecraft:oak_log" }
        //};
        Console.WriteLine(JsonConvert.SerializeObject(val));
        //Console.WriteLine(JsonConvert.SerializeObject(val2));
        await Network.Socket.Send($"OnCraftRequested(textutils.unserialiseJSON('{JsonConvert.SerializeObject(val)}'), 1)");
        //await Network.Socket.Send("WS.send(textutils.serialiseJSON({ Data = { ID = os.getComputerID(), Label = os.getComputerLabel() } }))");
    }
}
