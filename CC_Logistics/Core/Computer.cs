using Newtonsoft.Json;

namespace CC_Logistics;

public class Computer
{
    public int ID { get; set; }
    public string Label { get; set; }

    public virtual async Task Init()
    {
        var allItemsInConnectedInventories = await GetAllItemsInConnectedInventories();
        Console.WriteLine($"Received items: {allItemsInConnectedInventories.Data}");
        Console.WriteLine($"Received items count: {allItemsInConnectedInventories.Data.Count}");

        var connectedDevices = await GetConnectedDevices();
        Console.WriteLine($"Received devices: {connectedDevices.Data}");
        Console.WriteLine($"Received devices count: {connectedDevices.Data.Count}");
    }
    public async Task<Message<Dictionary<string,int>>> GetAllItemsInConnectedInventories()
    {
        await Network.Socket.Send("WS.send(textutils.serialiseJSON({ ID = os.getComputerID(), Label = os.getComputerLabel(), Data = GetAllItemsInConnectedInventories() }))");
        var message = JsonConvert.DeserializeObject<Message<Dictionary<string, int>>>(await Network.GetNextMessage());
        return message;
    }
    public async Task<Message<List<string>>> GetConnectedDevices()
    {
        await Network.Socket.Send("WS.send(textutils.serialiseJSON({ ID = os.getComputerID(), Label = os.getComputerLabel(), Data = peripheral.getNames() }))");
        var message = JsonConvert.DeserializeObject<Message<List<string>>>(await Network.GetNextMessage());
        return message;
    }
}
