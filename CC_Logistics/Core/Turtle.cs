namespace CC_Logistics;

public class Turtle : Computer
{
    public async Task Craft(Recipe recipe)
    {
        await Network.Socket.Send("WS.send(textutils.serialiseJSON({ Data = { ID = os.getComputerID(), Label = os.getComputerLabel() } }))");
    }
}
