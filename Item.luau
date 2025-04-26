--!strict
--!native

local ItemTypes = require(script.Parent.ItemTypes)
local Types = require(script.Parent.Types)

local Item = {}
Item.__index = Item

function Item.new(itemType: string, amount: number?) : Types.Item
	local self = {}
	setmetatable(self, Item)

	self.Item = itemType
	if amount then
		self.Amount = amount
	else
		self.Amount = 0
	end
	self.MaxAmount = ItemTypes[itemType].MaxAmount
	self.Index = nil

	return self :: Types.Item
end

return Item :: typeof(Item)