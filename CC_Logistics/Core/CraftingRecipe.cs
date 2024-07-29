namespace CC_Logistics;

/// <summary>
/// Defines a recipe for crafting products.
/// </summary>
public struct CraftingRecipe : IRecipe
{
    public static readonly ICollection<CraftingRecipe> RecipeCatalogue =
    [
        new()
        {
            Ingredients = new Dictionary<string, int>() { { "minecraft:cobblestone", 8 } },
            Products = ["minecraft:furnace"],
            KeepStockAmount = 0,
            Priority = 100,
            MaxBatchSize = 64,
            AllowSimilarIngedients = true,
            Pattern = new Dictionary<int, string>()
            {
                { 1, "minecraft:cobblestone" },
                { 2, "minecraft:cobblestone" },
                { 3, "minecraft:cobblestone" },
                { 4, "minecraft:cobblestone" },
                { 6, "minecraft:cobblestone" },
                { 7, "minecraft:cobblestone" },
                { 8, "minecraft:cobblestone" },
                { 9, "minecraft:cobblestone" }
            }
        }
    ];
    public Dictionary<string, int> Ingredients { get; set; }
    public ICollection<string> Products { get; set; }
    public int KeepStockAmount { get; set; }
    public int Priority { get; set; }
    public int MaxBatchSize { get; set; }
    public bool AllowSimilarIngedients { get; set; }

    /// <summary>
    /// The recipe / 3x3 pattern for crafting the product.
    /// </summary>
    public Dictionary<int, string> Pattern { get; set; }
}
