namespace CC_Logistics;

/// <summary>
/// Defines a recipe for processing products.
/// </summary>
public struct ProcessingRecipe : IRecipe
{
    public Dictionary<string, int> Ingredients { get; set; }
    public ICollection<string> Products { get; set; }
    public int KeepStockAmount { get; set; }
    public int Priority { get; set; }
    public int MaxBatchSize { get; set; }
    public bool AllowSimilarIngedients { get; set; }

    /// <summary>
    /// The machine(s) that can be used to craft the product.
    /// </summary>
    public ICollection<string> Machine { get; set; }
}
