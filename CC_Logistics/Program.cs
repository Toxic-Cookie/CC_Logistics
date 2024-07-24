using Fleck;

namespace CC_Logistics
{
    public static class Program
    {
        static readonly WebSocketServer Server = new("ws://127.0.0.1:8181/");
        static IWebSocketConnection Socket;
        static async Task Main(string[] args)
        {
            Server.Start(socket =>
            {
                Socket = socket;
                socket.OnOpen = OnOpen;
                socket.OnClose = OnClose;
                socket.OnMessage = OnMessage;
            });

            await Task.Run(() => Console.ReadKey(intercept: true));
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
            Socket.Send(message);
            Console.WriteLine($"Sent message: {message}");
        }
    }
}
