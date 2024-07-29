namespace CC_Logistics;

/// <summary>
/// Defines a recipe for crafting products.
/// </summary>
public struct CraftingRecipe : IRecipe
{
    public ICollection<string> Ingedients { get; set; }
    public ICollection<string> Products { get; set; }
    public bool KeepStock { get; set; }
    public int KeepStockAmount { get; set; }
    public int Priority { get; set; }
    public int MaxBatchSize { get; set; }
}
