namespace CC_Logistics;

/// <summary>
/// Defines a recipe for processing products.
/// </summary>
public struct ProcessingRecipe : IRecipe
{
    public ICollection<string> Ingedients { get; set; }
    public ICollection<string> Products { get; set; }
    public bool KeepStock { get; set; }
    public int KeepStockAmount { get; set; }
    public int Priority { get; set; }
    public int MaxBatchSize { get; set; }

    /// <summary>
    /// The machine(s) that can be used to craft the product.
    /// </summary>
    public ICollection<string> Machine { get; set; }
}
