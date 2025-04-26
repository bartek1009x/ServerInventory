--!strict
--!native

local ItemClass = require(script.Item)
local ItemTypes = require(script.ItemTypes)
local Types = require(script.Types)

local ServerInventory = {}
ServerInventory.__index = ServerInventory

function ServerInventory.new(maxSlots: number?) : Types.ServerInventory
	local self = {}
	setmetatable(self, ServerInventory)

	self.Inventory = {} :: Types.Inventory

	self.MaxSlots = (maxSlots or math.huge) :: number

	self.ItemAddedEvent = Instance.new("BindableEvent") :: BindableEvent
	self.ItemAdded = self.ItemAddedEvent.Event :: RBXScriptSignal
	self.ItemDeletedEvent = Instance.new("BindableEvent") :: BindableEvent
	self.ItemDeleted = self.ItemDeletedEvent.Event :: RBXScriptSignal
	self.ItemUpdatedEvent = Instance.new("BindableEvent") :: BindableEvent
	self.ItemUpdated = self.ItemUpdatedEvent.Event :: RBXScriptSignal

	return self :: Types.ServerInventory
end

function ServerInventory:updateIndexs() : ()
	for i, item in ipairs(self.Inventory :: Types.Inventory) do
		item.Index = i
	end
end

function ServerInventory:CreateItem(itemToCreate: string, amount: number) : Types.Item?
	if #self.Inventory :: Types.Inventory >= self.MaxSlots then return nil end
	local newItem = ItemClass.new(itemToCreate, amount)
	newItem.Index = #self.Inventory + 1
	table.insert(self.Inventory, newItem)
	self.ItemAddedEvent:Fire(newItem, #self.Inventory)
	return newItem
end

function ServerInventory:AddToItem(item: Types.Item, amount: number) : ()
	item.Amount += math.min(amount, item.MaxAmount)
	self.ItemUpdatedEvent:Fire(item, item.Index)
end

function ServerInventory:SubtractFromItem(item: Types.Item, amount: number) : ()
	item.Amount -= amount
	if item.Amount <= 0 then
		self.ItemDeletedEvent:Fire(item, item.Index)
		table.remove(self.Inventory, item.Index)

		self:updateIndexs()
	else
		self.ItemUpdatedEvent:Fire(item, item.Index)
	end
end

function ServerInventory:AddToItems(itemToAdd: string, amount: number) : ()
	local amountLeftToDistribute = amount

	for _, itemInInventory in pairs(self.Inventory :: Types.Inventory) do
		if itemInInventory.Item == itemToAdd and itemInInventory.Amount < itemInInventory.MaxAmount then
			local amountToAdd = math.clamp(amountLeftToDistribute, 0, itemInInventory.MaxAmount - itemInInventory.Amount)
			amountLeftToDistribute -= amountToAdd
			itemInInventory.Amount += amountToAdd
			self.ItemUpdatedEvent:Fire(itemInInventory, itemInInventory.Index)

			if amountLeftToDistribute == 0 then break end
		end
	end

	if amountLeftToDistribute > 0 then
		repeat
			if #self.Inventory :: Types.Inventory >= self.MaxSlots then break end

			local amountToAdd = math.clamp(amountLeftToDistribute, 0, ItemTypes[itemToAdd].MaxAmount)
			amountLeftToDistribute -= amountToAdd

			local item = ItemClass.new(itemToAdd, amountToAdd)
			item.Index = #self.Inventory + 1
			table.insert(self.Inventory, item)

			self.ItemAddedEvent:Fire(item, #self.Inventory)

		until amountLeftToDistribute == 0
	end

end

function ServerInventory:SubtractFromItems(itemToSubtract: string, amount: number) : ()
	local amountLeftToDistribute = amount
	local itemsToDelete = {}

	for index, itemInInventory in pairs(self.Inventory :: Types.Inventory) do
		if itemInInventory.Item == itemToSubtract then
			local amountToRemove = math.clamp(amountLeftToDistribute, 0, itemInInventory.Amount)
			if itemInInventory.Amount - amountToRemove == 0 then
				table.insert(itemsToDelete, index)
				self.ItemDeletedEvent:Fire(self.Inventory[index], index)
			end

			amountLeftToDistribute -= amountToRemove
			itemInInventory.Amount -= amountToRemove
			if itemInInventory.Amount > 0 then
				self.ItemUpdatedEvent:Fire(itemInInventory, itemInInventory.Index)
			end

			if amountLeftToDistribute == 0 then break end
		end
	end

	for i = #itemsToDelete, 1, -1 do
		table.remove(self.Inventory, itemsToDelete[i])
		self:updateIndexs()
	end

end

function ServerInventory:DeleteItem(itemIndex: number) : ()
	if self.Inventory[itemIndex] then
		self.ItemDeletedEvent:Fire(self.Inventory[itemIndex], itemIndex)
		table.remove(self.Inventory, itemIndex)

		self:updateIndexs()
	end
end

function ServerInventory:FindFirstItem(itemName: string): {item: Types.Item, index: number}?
	for index, item in pairs(self.Inventory :: Types.Inventory) do
		if item.Item == itemName then
			return {item, index} :: {item: Types.Item, index: number}
		end
	end
	return nil
end

-- honestly I don't remember why I put task.wait() here, but I'll leave it just in case
function ServerInventory:Clear() : ()
	for _, item in pairs(self.Inventory :: Types.Inventory) do
		self:DeleteItem(item.Index)
		task.wait()
	end
end

return table.freeze(ServerInventory) :: typeof(ServerInventory)