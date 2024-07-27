using Fleck;
using Newtonsoft.Json;

namespace CC_Logistics;

public static class Network
{
    // 8080 for dev. 8181 for prod.
    static readonly WebSocketServer Server = new("ws://0.0.0.0:8080/");
    public static IWebSocketConnection Socket { get; private set; }
    static void Main(string[] args)
    {
        OnSocketOpened += HandleOnOpen;

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

	public static event Action OnSocketOpened;
    static void OnOpen()
    {
        Console.WriteLine("Socket opened.");

        OnSocketOpened?.Invoke();
    }
    static async void HandleOnOpen()
    {
        await Socket.Send("WS.send(os.getComputerID())");
        //await Socket.Send("\"WS.send(textutils.serialiseJSON({ ID = os.getComputerID(), Label = os.getComputerLabel() }))\"");
        //var message = JsonConvert.DeserializeObject<Message>(await GetNextMessage());
        //Computers.Add(new Computer { ID = message.ID, Label = message.Label });
        //Console.WriteLine($"Connected to computer {message.Label} with ID {message.ID}.");
    }

    public static event Action OnSocketClosed;
    static void OnClose()
    {
        Console.WriteLine("Socket closed.");

        OnSocketClosed?.Invoke();
    }
    public static event Action<string> OnSocketMessage;
    static void OnMessage(string message)
    {
        Console.WriteLine($"Received message: {message}");
        //Socket.Send(message);
        //var c = JsonConvert.DeserializeObject<Message>(message);
        //await Socket.Send($"print('hiii')");
        OnSocketMessage?.Invoke(message);
    }
    
    public static Task<string> GetNextMessage()
    {
        var tcs = new TaskCompletionSource<string>();
        OnSocketMessage += tcs.SetResult;
        tcs.Task.ContinueWith(_ => OnSocketMessage -= tcs.SetResult);
        return tcs.Task;
    }

    public static readonly Dictionary<string, int> Items = [];
    public static readonly List<Computer> Computers = [];
}
