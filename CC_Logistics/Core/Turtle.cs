namespace CC_Logistics;
using Newtonsoft.Json;

public class Turtle : Computer
{
    public override async Task Init()
    {
        await base.Init();
        //await Craft(new CraftingRecipe() { Pattern = new Dictionary<int, string>() { { 1, "minecraft:oak_planks" }, { 4, "minecraft:oak_planks" } } }, 1);
        await Craft(new CraftingRecipe() 
        { 
            Pattern = new Dictionary<int, string>() { 
                { 1, "minecraft:cobblestone" },
                { 2, "minecraft:cobblestone" },
                { 3, "minecraft:cobblestone" },
                { 4, "minecraft:cobblestone" },
                { 6, "minecraft:cobblestone" },
                { 7, "minecraft:cobblestone" },
                { 8, "minecraft:cobblestone" },
                { 9, "minecraft:cobblestone" },
            },
            Products = ["minecraft:furnace"]
        }, 1);
    }
    public async Task Craft(CraftingRecipe recipe, int amount)
    {
        var guid = Guid.NewGuid();
        Console.WriteLine($"Crafting {amount} of {recipe.Products.First()}.");
        await Network.Socket.Send("GUI:addProgram():execute(function() OnCraftRequested(textutils.unserialiseJSON('" + JsonConvert.SerializeObject(recipe.Pattern) +"'), " + amount 
            + ") end):hide():onDone(function() WS.send(textutils.serialiseJSON({ ID = os.getComputerID(), Label = os.getComputerLabel(), Data = '" + guid + "' })) end)");
        var message = JsonConvert.DeserializeObject<Message<string>>(await Network.GetNextMessage<Guid>(x => x.Data == guid ));
        Console.WriteLine($"Crafted {amount} of {recipe.Products.First()}.");
    }
}
