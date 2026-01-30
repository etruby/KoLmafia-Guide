
// TakerSpace (February 2025 IOTM)
// A workshed that provides daily pirate crafting supplies
// Daily supplies: 3 spice, 3 rum, 3 anchor, 3 mast, 1 silk, 1 gold
// Craft various pirate-themed items from these resources

// Recipe data: [item_name, spice, rum, anchor, mast, silk, gold, description]
string [int][int] __takerspace_recipes;

void initTakerSpaceRecipes()
{
	if (__takerspace_recipes.count() > 0) return;

	// Recipes from wiki - format: [name, spice, rum, anchor, mast, silk, gold, description]
	__takerspace_recipes[0] = listMake("deft pirate hook", "0", "0", "1", "1", "0", "1", "Offhand, pickpocket (Melting)");
	__takerspace_recipes[1] = listMake("iron tricorn hat", "0", "0", "2", "1", "0", "0", "Hat, stun skill (Melting)");
	__takerspace_recipes[2] = listMake("jolly roger flag", "0", "1", "0", "1", "1", "0", "Accessory, banish (Melting)");
	__takerspace_recipes[3] = listMake("sleeping profane parrot", "15", "3", "0", "0", "2", "1", "Sleaze potato familiar");
	__takerspace_recipes[4] = listMake("pirrrate's currrse", "2", "2", "0", "0", "0", "0", "Chat curse item");
	__takerspace_recipes[5] = listMake("tankard of spiced rum", "1", "2", "0", "0", "0", "0", "Size 1 Awesome booze");
	__takerspace_recipes[6] = listMake("tankard of spiced Goldschlepper", "0", "2", "0", "0", "0", "1", "Size 1 EPIC booze");
	__takerspace_recipes[7] = listMake("packaged luxury garment", "0", "0", "0", "0", "3", "2", "Random fancy item");
	__takerspace_recipes[8] = listMake("harpoon", "0", "0", "0", "2", "0", "0", "Combat item");
	__takerspace_recipes[9] = listMake("chili powder cutlass", "5", "0", "1", "0", "0", "0", "1-handed sword");
	__takerspace_recipes[10] = listMake("cursed Aztec tamale", "2", "0", "0", "0", "0", "0", "Size 1 Awesome food");
	__takerspace_recipes[11] = listMake("jolly roger tattoo kit", "0", "6", "1", "1", "0", "6", "Unlocks tattoo");
	__takerspace_recipes[12] = listMake("golden pet rock", "0", "0", "0", "0", "0", "7", "Pet rock familiar");
	__takerspace_recipes[13] = listMake("groggles", "0", "6", "0", "0", "0", "0", "+50% Booze drop accessory");
	__takerspace_recipes[14] = listMake("pirate dinghy", "0", "0", "1", "1", "1", "0", "Mysterious Island access");
	__takerspace_recipes[15] = listMake("anchor bomb", "0", "1", "3", "1", "0", "1", "30-turn free-run banisher");
	__takerspace_recipes[16] = listMake("silky pirate drawers", "0", "0", "0", "0", "2", "0", "-Combat% pants");
	__takerspace_recipes[17] = listMake("spices", "1", "0", "0", "0", "0", "0", "They're spices!");
}

boolean takerSpaceIsAvailable()
{
	// Check if TakerSpace is in workshed via get_campground()
	if (!$item[TakerSpace letter of Marque].is_unrestricted()) return false;
	if (__misc_state["campground unavailable"]) return false;

	int [item] campground = get_campground();
	// The TakerSpace appears in campground when installed
	if (campground contains $item[TakerSpace letter of Marque])
		return true;

	// Also check if any TakerSpace resources exist (indicates it's been used)
	if (get_property_int("takerSpaceSpice") > 0) return true;
	if (get_property_int("takerSpaceRum") > 0) return true;
	if (get_property_int("takerSpaceAnchor") > 0) return true;
	if (get_property_int("takerSpaceMast") > 0) return true;
	if (get_property_int("takerSpaceSilk") > 0) return true;
	if (get_property_int("takerSpaceGold") > 0) return true;

	return false;
}

// Check if a recipe can be crafted with current resources
boolean canCraftRecipe(int recipe_index, int spice, int rum, int anchor, int mast, int silk, int gold)
{
	initTakerSpaceRecipes();
	if (!(__takerspace_recipes contains recipe_index)) return false;

	int req_spice = __takerspace_recipes[recipe_index][1].to_int();
	int req_rum = __takerspace_recipes[recipe_index][2].to_int();
	int req_anchor = __takerspace_recipes[recipe_index][3].to_int();
	int req_mast = __takerspace_recipes[recipe_index][4].to_int();
	int req_silk = __takerspace_recipes[recipe_index][5].to_int();
	int req_gold = __takerspace_recipes[recipe_index][6].to_int();

	return (spice >= req_spice && rum >= req_rum && anchor >= req_anchor &&
	        mast >= req_mast && silk >= req_silk && gold >= req_gold);
}

string getRecipeCost(int recipe_index)
{
	initTakerSpaceRecipes();
	if (!(__takerspace_recipes contains recipe_index)) return "";

	string [int] costs;
	int req_spice = __takerspace_recipes[recipe_index][1].to_int();
	int req_rum = __takerspace_recipes[recipe_index][2].to_int();
	int req_anchor = __takerspace_recipes[recipe_index][3].to_int();
	int req_mast = __takerspace_recipes[recipe_index][4].to_int();
	int req_silk = __takerspace_recipes[recipe_index][5].to_int();
	int req_gold = __takerspace_recipes[recipe_index][6].to_int();

	if (req_spice > 0) costs.listAppend(req_spice + " spice");
	if (req_rum > 0) costs.listAppend(req_rum + " rum");
	if (req_anchor > 0) costs.listAppend(req_anchor + " anchor");
	if (req_mast > 0) costs.listAppend(req_mast + " mast");
	if (req_silk > 0) costs.listAppend(req_silk + " silk");
	if (req_gold > 0) costs.listAppend(req_gold + " gold");

	return costs.listJoinComponents(", ");
}

RegisterResourceGenerationFunction("IOTMTakerSpaceGenerateResource");
void IOTMTakerSpaceGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!takerSpaceIsAvailable()) return;

	initTakerSpaceRecipes();

	string [int] description;
	string url = "campground.php?action=workshed";

	// Get current resources
	int spice = get_property_int("takerSpaceSpice");
	int rum = get_property_int("takerSpaceRum");
	int anchor = get_property_int("takerSpaceAnchor");
	int mast = get_property_int("takerSpaceMast");
	int silk = get_property_int("takerSpaceSilk");
	int gold = get_property_int("takerSpaceGold");

	// Check if daily supplies have been collected
	boolean supplies_delivered = get_property_boolean("_takerSpaceSuppliesDelivered");

	// Show daily supplies status
	if (!supplies_delivered)
	{
		description.listAppend(HTMLGenerateSpanFont("Collect daily supplies!", "red") + " (+3 spice, +3 rum, +3 anchor, +3 mast, +1 silk, +1 gold)");
	}

	// Show current resources
	string [int] resource_list;
	resource_list.listAppend(spice + " spice");
	resource_list.listAppend(rum + " rum");
	resource_list.listAppend(anchor + " anchor");
	resource_list.listAppend(mast + " mast");
	resource_list.listAppend(silk + " silk");
	resource_list.listAppend(gold + " gold");
	description.listAppend("Supplies: " + resource_list.listJoinComponents(", "));

	// Find craftable items with current resources
	string [int] craftable;
	string [int] notable_craftable;

	foreach i in __takerspace_recipes
	{
		if (canCraftRecipe(i, spice, rum, anchor, mast, silk, gold))
		{
			string item_name = __takerspace_recipes[i][0];
			string item_desc = __takerspace_recipes[i][7];
			string cost = getRecipeCost(i);

			// Highlight notable items for speedruns
			if (item_name == "anchor bomb" || item_name == "jolly roger flag" ||
			    item_name == "deft pirate hook" || item_name == "iron tricorn hat" ||
			    item_name == "pirate dinghy")
			{
				notable_craftable.listAppend(item_name + " - " + item_desc + " (" + cost + ")");
			}
			else
			{
				craftable.listAppend(item_name + " (" + cost + ")");
			}
		}
	}

	// Show notable craftable items first
	if (notable_craftable.count() > 0)
	{
		description.listAppend("Notable craftables:|*" + notable_craftable.listJoinComponents("|*"));
	}

	// Show other craftable items
	if (craftable.count() > 0)
	{
		description.listAppend("Other craftables:|*" + craftable.listJoinComponents("|*"));
	}

	if (notable_craftable.count() == 0 && craftable.count() == 0 && (spice > 0 || rum > 0 || anchor > 0 || mast > 0 || silk > 0 || gold > 0))
	{
		description.listAppend("No items craftable with current supplies.");
	}

	// Recommendations for speedruns
	if (__misc_state["in run"])
	{
		string [int] recommendations;

		// Check for pirate dinghy if needed for island access
		if (!canCraftRecipe(14, spice, rum, anchor, mast, silk, gold) && !get_property_ascension("lastIslandUnlock"))
		{
			// pirate dinghy costs: 0 spice, 0 rum, 1 anchor, 1 mast, 1 silk, 0 gold
			if (anchor < 1 || mast < 1 || silk < 1)
			{
				string needed = "";
				if (anchor < 1) needed += "1 anchor ";
				if (mast < 1) needed += "1 mast ";
				if (silk < 1) needed += "1 silk";
				// Only mention if they're close
				if ((anchor >= 0 && mast >= 0 && silk >= 0) && (anchor + mast + silk >= 1))
				{
					recommendations.listAppend("Save for pirate dinghy (need " + needed + ") for Island access");
				}
			}
		}

		// Check for anchor bomb (free-run banish)
		if (!canCraftRecipe(15, spice, rum, anchor, mast, silk, gold))
		{
			// anchor bomb costs: 0 spice, 1 rum, 3 anchor, 1 mast, 0 silk, 1 gold
			if (anchor >= 1 || mast >= 1 || rum >= 1 || gold >= 1)
			{
				recommendations.listAppend("Consider saving for anchor bomb (30-turn free-run banish)");
			}
		}

		if (recommendations.count() > 0)
		{
			description.listAppend("Tips:|*" + recommendations.listJoinComponents("|*"));
		}
	}

	string title = "TakerSpace";
	if (!supplies_delivered)
		title += " (supplies ready!)";

	// Use a reasonable importance - higher if supplies uncollected
	int importance = supplies_delivered ? 8 : 5;

	resource_entries.listAppend(ChecklistEntryMake(11687, "__item TakerSpace letter of Marque", url, ChecklistSubentryMake(title, "", description), importance));
}

// Task generation for collecting supplies
RegisterTaskGenerationFunction("IOTMTakerSpaceGenerateTasks");
void IOTMTakerSpaceGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!takerSpaceIsAvailable())
	{
		if ($item[TakerSpace letter of Marque].is_unrestricted() && $item[TakerSpace letter of Marque].available_amount() > 0)
		{
			string [int] description;
			description.listAppend("Install the TakerSpace in your workshed to receive daily pirate crafting supplies.");
			description.listAppend("Provides 3 spice, 3 rum, 3 anchor, 3 mast, 1 silk, and 1 gold each day.");

			optional_task_entries.listAppend(ChecklistEntryMake(11687, "__item TakerSpace letter of Marque", "inventory.php?which=3&ftext=TakerSpace", ChecklistSubentryMake("Install TakerSpace workshed", "", description), 5));
		}

		return;
	}

	boolean supplies_delivered = get_property_boolean("_takerSpaceSuppliesDelivered");

	// Remind to collect daily supplies
	if (!supplies_delivered)
	{
		string [int] description;
		description.listAppend("Visit your TakerSpace to collect daily pirate supplies.");
		description.listAppend("+3 spice, +3 rum, +3 anchor, +3 mast, +1 silk, +1 gold");

		optional_task_entries.listAppend(ChecklistEntryMake(11687, "__item TakerSpace letter of Marque", "campground.php?action=workshed", ChecklistSubentryMake("Collect TakerSpace supplies", "", description), 5));
	}
}
