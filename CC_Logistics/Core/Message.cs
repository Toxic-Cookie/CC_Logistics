namespace CC_Logistics;

public struct Message
{
    public int ID { get; set; }
    public string Label { get; set; }
}
public struct Message<T>
{
    public int ID { get; set; }
    public string Label { get; set; }
    public T Data { get; set; }
}
