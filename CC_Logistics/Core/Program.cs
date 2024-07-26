using Fleck;
using Newtonsoft;
using Newtonsoft.Json;

namespace CC_Logistics;

public static class Program
{
    // 8080 for dev. 8181 for prod.
    static readonly WebSocketServer Server = new("ws://0.0.0.0:8080/");
    static IWebSocketConnection Socket;
    static void Main(string[] args)
    {
        Server.Start(socket =>
        {
            Socket = socket;
            socket.OnOpen = OnOpen;
            socket.OnClose = OnClose;
            socket.OnMessage = OnMessage;
        });

        while (true)
        {

        }
    }

    static void OnOpen()
    {
        Console.WriteLine("Opened!");
    }
    static void OnClose()
    {
        Console.WriteLine("Closed!");
    }
    static void OnMessage(string message)
    {
        //Socket.Send(message);
        Console.WriteLine($"Got message: {message}");
        var c = JsonConvert.DeserializeObject<Message<Computer>>(message);
        Console.WriteLine($"Computer ID: {c.Data.ID} Label: {c.Data.Label}");
        Socket.Send($"print('hiii')");
    }
}
