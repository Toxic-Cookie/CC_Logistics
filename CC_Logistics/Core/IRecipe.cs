namespace CC_Logistics;

/// <summary>
/// Defines a recipe for creating products.
/// </summary>
public interface IRecipe
{
    /// <summary>
    /// The input ingredients required to craft the product.
    /// </summary>
    public ICollection<string> Ingedients { get; set; }
    /// <summary>
    /// The product that is crafted.
    /// </summary>
    public ICollection<string> Products { get; set; }
    /// <summary>
    /// Whether the product should be kept in stock.
    /// </summary>
    public bool KeepStock { get; set; }
    /// <summary>
    /// The amount of the product to keep in stock.
    /// </summary>
    public int KeepStockAmount { get; set; }
    /// <summary>
    /// The priority of the recipe.
    /// </summary>
    public int Priority { get; set; }
    /// <summary>
    /// The maximum amount of product that can be crafted in a single batch.
    /// </summary>
    public int MaxBatchSize { get; set; }
}
