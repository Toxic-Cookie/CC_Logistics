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
        await Socket.Send("WS.send(textutils.serialiseJSON({ ID = os.getComputerID(), Label = os.getComputerLabel(), Data = turtle == nil }))");
        var message = JsonConvert.DeserializeObject<Message<bool>>(await GetNextMessage());
        if (message.Data)
        {
            Console.WriteLine($"Connected to computer {message.Label} with ID {message.ID}.");
            var computer = new Computer { ID = message.ID, Label = message.Label };
            await computer.Init();
        }
        else
        {
            Console.WriteLine($"Connected to turtle {message.Label} with ID {message.ID}.");
            var turtle = new Turtle { ID = message.ID, Label = message.Label };
            await turtle.Init();
        }
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

        OnSocketMessage?.Invoke(message);
    }
    
    public static Task<string> GetNextMessage()
    {
        var tcs = new TaskCompletionSource<string>();
        OnSocketMessage += tcs.SetResult;
        tcs.Task.ContinueWith(_ => OnSocketMessage -= tcs.SetResult);
        return tcs.Task;
    }
    public static Task<string> GetNextMessage(Predicate<Message> predicate)
    {
        var tcs = new TaskCompletionSource<string>();
        OnSocketMessage += message =>
        {
            var deserializedMessage = JsonConvert.DeserializeObject<Message>(message);
            if (predicate(deserializedMessage))
            {
                tcs.SetResult(message);
            }
        };
        tcs.Task.ContinueWith(_ => OnSocketMessage -= tcs.SetResult);
        return tcs.Task;
    }
    public static Task<string> GetNextMessage<T>(Predicate<Message<T>> predicate)
    {
        var tcs = new TaskCompletionSource<string>();
        OnSocketMessage += message =>
        {
            var deserializedMessage = JsonConvert.DeserializeObject<Message<T>>(message);
            if (predicate(deserializedMessage))
            {
                tcs.SetResult(message);
            }
        };
        tcs.Task.ContinueWith(_ => OnSocketMessage -= tcs.SetResult);
        return tcs.Task;
    }
}
