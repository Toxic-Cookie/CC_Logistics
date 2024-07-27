namespace CC_Logistics;

/// <summary>
/// Defines a recipe for crafting products.
/// </summary>
public class Recipe
{
    /// <summary>
    /// The input ingredients required to craft the product.
    /// </summary>
    public readonly ICollection<string> Ingedients = [];
    /// <summary>
    /// The product that is crafted.
    /// </summary>
    public readonly ICollection<string> Products = [];
    /// <summary>
    /// The machine that crafts the product.
    /// </summary>
    public readonly string Machine;
}
