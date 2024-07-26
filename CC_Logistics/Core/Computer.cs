namespace CC_Logistics;

public class Computer
{
    public int ID { get; set; }
    public string Label { get; set; }
}

public class Message<T>
{
    public T Data { get; set; }
}
