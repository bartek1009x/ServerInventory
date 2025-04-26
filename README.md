# ServerInventory
### A minimal (you could even say barebones) server-side inventory system for Roblox. Meant to be simple and easily modifiable.
I wrote it a few months ago and decided that I might as well share it. It seemed to work properly, but if there are any issues, you can always report them.
It's fully typed (except for item definitions, since these are meant to be customized to your liking).
It's also fully server-side, sending inventory information to the client is left up to you.

To start using the module, put it in a place like e.g. ServerScriptService and require it in your script.

**If you're using Rojo, you can just create a folder called "ServerInventory" and put all the source code files in it.**

Here's some example code to give you a basic idea of how to use the module:

```luau

local ServerInventory = require(game:GetService("ServerScriptService").ServerInventory)
local ServerInventoryTypes = require(game:GetService("ServerScriptService").ServerInventory.Types)

local playerInventories = {}

game:GetService("Players").PlayerAdded:Connect(function(player: Player)
  -- 12 is the max amount of slots in this inventory
  playerInventories[player.UserId] = ServerInventory.new(12)

  playerInventories[player.UserId].ItemAdded:Connect(function(item: ServerInventoryTypes.Item, index: number)
       -- item.Item is basically the item's name
       print(`{item.Amount}x {item.Item}s have been added`)
       -- this could for example print something like 25x Apples have been added
  end)

  playerInventories[player.UserId].ItemUpdated:Connect(function(item: ServerInventoryTypes.Item, index: number)
       print("The amount has changed, maybe there's more now, or maybe there's less now, who knows")
  end)

  playerInventories[player.UserId].ItemDeleted:Connect(function(item: ServerInventoryTypes.Item, index: number)
       print(`{item.Item} with index {item.Index} has been removed`)
  end)

  playerInventories[player.UserId]:AddToItems("Apple", 10)
  -- AddToItems will, as the name suggests, add 10 Apples to the Inventory. If there's already an Apple item in the inventory and its amount isn't equal to its maxAmount, then 10 will be added to that item's amount instead of creating a new item in the inventory

  playerInventories[player.UserId]:CreateItem("Apple", 5)
  -- CreateItem won't check if there already is an Apple item in the inventory and won't add to the amount of already existing Apple items. Instead it will create a new Apple item with the amount of 10
end

```
