export type Item = {
    Item: string,
    Amount: number,
    MaxAmount: number,
    Index: number?
}

export type NeoInventory = {
    Inventory: Inventory,
    MaxSlots: number?,

    CreateItem: (self: NeoInventory, itemToCreate: string, amount: number) -> (Item),
    AddToItem: (self: NeoInventory, item: Item, amount: number) -> (),
    SubtractFromItem: (self: NeoInventory, item: Item, amount: number) -> (),
    AddToItems: (self: NeoInventory, itemToAdd: string, amount: number) -> (),
    SubtractFromItems: (self: NeoInventory, itemToSubtract: string, amount: number) -> (),
    DeleteItem: (self: NeoInventory, itemIndex: number) -> (),
    FindFirstItem: (self: NeoInventory, itemName: string) -> (Item?),

    ItemAdded: RBXScriptSignal,
    ItemDeleted: RBXScriptSignal,
    ItemUpdated: RBXScriptSignal
}

export type Inventory = {
    [number]: Types.Item
}

export type ItemInfo = {
    MaxAmount: number
}

return nil