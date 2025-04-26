return {
	
	-- You can define your items however you want
	-- The only property that is required for all items is MaxAmount and obviously it must be a number

	ExampleItem = {
		MaxAmount = 2,
		DisplayName = "Example Item",
		Icon = "http://www.roblox.com/asset/?id="
	},
	
	ExampleItem2 = {
		MaxAmount = math.huge,
		DisplayName = "Example Item 2",
		Icon = "http://www.roblox.com/asset/?id="
	}

} :: {[string]: Types.ItemInfo}