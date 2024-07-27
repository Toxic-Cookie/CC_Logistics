namespace CC_Logistics;

public class Computer
{
    public int ID { get; set; }
    public string Label { get; set; }

    public async Task Execute(string data)
    {
        await Network.Socket.Send("WS.send(textutils.serialiseJSON({ ID = os.getComputerID(), Label = os.getComputerLabel(), Data = { " + data + " } }))");
    }
    public async Task GetAllItemsInConnectedInventories()
    {
        await Execute("pairs(GetAllItemsInConnectedInventories(), DiscardNamespaceSort)");
    }
}
