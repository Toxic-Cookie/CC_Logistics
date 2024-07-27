namespace CC_Logistics;

public class Message
{
    public int ID { get; set; }
    public string Label { get; set; }
}
public class Message<T>
{
    public int ID { get; set; }
    public string Label { get; set; }
    public T Data { get; set; }
}
