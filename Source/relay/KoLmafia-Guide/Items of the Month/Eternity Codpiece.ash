
// Structure to hold gem information
record GemInfo
{
	item gem_item;
	string enchantment;
	string category;
};

GemInfo GemInfoMake(item gem_item, string enchantment, string category)
{
	GemInfo g;
	g.gem_item = gem_item;
	g.enchantment = enchantment;
	g.category = category;
	return g;
}

void listAppend(GemInfo [int] list, GemInfo entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

RegisterResourceGenerationFunction("IOTMEternityCodepieceGenerateResource");
void IOTMEternityCodepieceGenerateResource(ChecklistEntry [int] resource_entries)
{
	item codpiece = $item[The Eternity Codpiece];

	// Codpiece is automatically given at start of run, but check anyway
	if (codpiece.available_amount() == 0) return;

	string [int] description;
	string url = "inventory.php?pwd=" + my_hash() + "&action=docodpiece";

	// Define all gems with their enchantments (from wiki)
	GemInfo [int] all_gems;

	// IOTM Gems
	all_gems.listAppend(GemInfoMake($item[Peridot of Peril], "Max HP +20, Max MP +20", "IOTM"));
	all_gems.listAppend(GemInfoMake($item[blood cubic zirconia], "Spooky res +3, +5 Spooky dmg", "IOTM"));

	// High Value Gems
	all_gems.listAppend(GemInfoMake($item[solid gold jewel], "Max HP +20%", "High Value"));
	all_gems.listAppend(GemInfoMake($item[unblemished pearl], "+1 adv/day", "High Value"));
	all_gems.listAppend(GemInfoMake($item[incredibly dense meat gem], "+30% meat", "High Value"));
	all_gems.listAppend(GemInfoMake($item[massive gemstone], "+10% item", "High Value"));
	all_gems.listAppend(GemInfoMake($item[rainbow pearl], "+5 prismatic dmg", "High Value"));
	all_gems.listAppend(GemInfoMake($item[Tuesday's ruby], "+5 ML", "High Value"));
	all_gems.listAppend(GemInfoMake($item[eye of the Tiger-lily], "Spell dmg +10%", "High Value"));

	// Stat Gems
	all_gems.listAppend(GemInfoMake($item[baconstone], "Myst +11%", "Stats"));
	all_gems.listAppend(GemInfoMake($item[hamethyst], "Mus +11%", "Stats"));
	all_gems.listAppend(GemInfoMake($item[porquoise], "Mox +11%", "Stats"));
	all_gems.listAppend(GemInfoMake($item[rhinestone], "+1 Mox stats/fight", "Stats"));
	all_gems.listAppend(GemInfoMake($item[alien gemstone], "+1 Mus stats/fight", "Stats"));
	all_gems.listAppend(GemInfoMake($item[autumn years wisdom], "+1 Myst stats/fight", "Stats"));
	all_gems.listAppend(GemInfoMake($item[crystallized memory], "+5 Mus", "Stats"));
	all_gems.listAppend(GemInfoMake($item[floaty inverse geode], "+5 Mox", "Stats"));
	all_gems.listAppend(GemInfoMake($item[control crystal], "+5 Myst", "Stats"));
	all_gems.listAppend(GemInfoMake($item[stone of eXtreme power], "All stats +3", "Stats"));

	// Combat Initiative Gems (Marbles)
	all_gems.listAppend(GemInfoMake($item[big bumboozer marble], "+11% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[black catseye marble], "+10% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[beach ball marble], "+9% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[steely marble], "+8% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[beige clambroth marble], "+7% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[jet bennie marble], "+6% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[bumblebee marble], "+5% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[lemonade marble], "+4% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[red China marble], "+3% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[brown crock marble], "+2% init", "Initiative"));
	all_gems.listAppend(GemInfoMake($item[green peawee marble], "+1% init", "Initiative"));

	// Elemental Damage Gems
	all_gems.listAppend(GemInfoMake($item[heart of the volcano], "+5 Hot dmg, +5 Hot spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[18-picohertz resonator crystal], "+5 Cold dmg, +5 Cold spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[chlorine crystal], "+5 Stench dmg, +5 Stench spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[crystalline cheer], "+5 Sleaze dmg, +5 Sleaze spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[void stone], "+5 Spooky dmg, +5 Spooky spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[Rubee&trade;], "+10 Hot dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[Azurite], "+10 Sleaze dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[Lapis Lazuli], "+10 Stench dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[shadow glass], "+10 Spooky dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[shard of double-ice], "+10 Cold dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[strawberyl], "+10 Hot spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[kumquartz], "+10 Cold spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[bananagate], "+10 Stench spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[pearidot], "+10 Sleaze spell dmg", "Elemental"));
	all_gems.listAppend(GemInfoMake($item[tourmalime], "+10 Spooky spell dmg", "Elemental"));

	// Resistance Gems
	all_gems.listAppend(GemInfoMake($item[effluvious emerald], "Stench res +2", "Resistance"));
	all_gems.listAppend(GemInfoMake($item[glacial sapphire], "Cold res +2", "Resistance"));
	all_gems.listAppend(GemInfoMake($item[steamy ruby], "Hot res +2", "Resistance"));
	all_gems.listAppend(GemInfoMake($item[tawdry amethyst], "Sleaze res +2", "Resistance"));
	all_gems.listAppend(GemInfoMake($item[unearthly onyx], "Spooky res +2", "Resistance"));

	// Monster Type Damage Gems
	all_gems.listAppend(GemInfoMake($item[Xiblaxian crystal], "+25% vs Bugbears", "vs Monsters"));
	all_gems.listAppend(GemInfoMake($item[moon-amber], "+25% vs Ghosts", "vs Monsters"));
	all_gems.listAppend(GemInfoMake($item[polished moon-amber], "+25% vs Werewolves", "vs Monsters"));
	all_gems.listAppend(GemInfoMake($item[Eye Agate], "+25% vs Zombies", "vs Monsters"));
	all_gems.listAppend(GemInfoMake($item[crystalline seal eye], "+25% vs Seals", "vs Monsters"));
	all_gems.listAppend(GemInfoMake($item[vampire pearl], "+25% vs Vampires", "vs Monsters"));

	// Drop Rate Gems
	all_gems.listAppend(GemInfoMake($item[barrel beryl], "+20% booze drops", "Drops"));
	all_gems.listAppend(GemInfoMake($item[BRICKO pearl], "+20% candy drops", "Drops"));
	all_gems.listAppend(GemInfoMake($item[crystallized pumpkin spice], "+20% food drops", "Drops"));

	// Regeneration Gems
	all_gems.listAppend(GemInfoMake($item[New Age healing crystal], "Regen 10-20 HP/adv", "Regen"));
	all_gems.listAppend(GemInfoMake($item[glowing New Age crystal], "Regen 5-10 MP/adv", "Regen"));

	// Miscellaneous Gems
	all_gems.listAppend(GemInfoMake($item[cubic zirconia], "Max MP +10%", "Misc"));
	all_gems.listAppend(GemInfoMake($item[lunar isotope], "+10% pickpocket", "Misc"));
	all_gems.listAppend(GemInfoMake($item[New Age hurting crystal], "Fam dmg +10", "Misc"));
	all_gems.listAppend(GemInfoMake($item[glimmering golden crystal], "+1 fam exp/fight", "Misc"));
	all_gems.listAppend(GemInfoMake($item[torquoise], "Weapon dmg +10%", "Misc"));
	all_gems.listAppend(GemInfoMake($item[lump of diamond], "Dmg reduction 5", "Misc"));
	all_gems.listAppend(GemInfoMake($item[priceless diamond], "Dmg absorption +10", "Misc"));
	all_gems.listAppend(GemInfoMake($item[angry agate], "+1 PvP fight/day", "Misc"));
	all_gems.listAppend(GemInfoMake($item[giant pearl], "+1 pool skill", "Misc"));
	all_gems.listAppend(GemInfoMake($item[marine aquamarine], "+5 fishing skill", "Misc"));

	// Build comprehensive gem table
	string [int][int] gem_table;
	gem_table.listAppend(listMake(
		HTMLGenerateSpanOfClass("Gem", "r_bold"),
		HTMLGenerateSpanOfClass("Enchantment", "r_bold"),
		HTMLGenerateSpanOfClass("Location", "r_bold")
	));

	int owned_count = 0;
	foreach idx in all_gems
	{
		GemInfo gem_info = all_gems[idx];
		item gem = gem_info.gem_item;

		// Check all possible locations
		int in_inventory = gem.item_amount();
		int in_closet = gem.closet_amount();
		int in_storage = gem.storage_amount();
		int total = in_inventory + in_closet + in_storage;

		if (total == 0) continue; // Skip gems we don't have
		owned_count++;

		// Build location string
		string [int] locations;
		if (in_inventory > 0) locations.listAppend("Inv");
		if (in_closet > 0) locations.listAppend("Closet");
		if (in_storage > 0) locations.listAppend("Storage");

		string location_text = locations.listJoinComponents(", ", "");

		// Color code IOTM gems
		string gem_name = gem.to_string();
		if (gem_info.category == "IOTM")
			gem_name = HTMLGenerateSpanFont(gem_name, "blue");

		gem_table.listAppend(listMake(gem_name, gem_info.enchantment, location_text));
	}

	if (owned_count > 0)
	{
		description.listAppend("Owned gems (accessible):|*" + HTMLGenerateSimpleTableLines(gem_table));
	}
	else
	{
		description.listAppend("No notable gems found in inventory, closet, or storage.");
	}

	// Build comprehensive gem tooltip showing ALL gems
	buffer tooltip_text;
	tooltip_text.HTMLAppendTagWrap("div", "All Unowned Gems", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;"));

	string [int][int] all_gems_table;
	all_gems_table.listAppend(listMake(
		HTMLGenerateSpanOfClass("Gem", "r_bold"),
		HTMLGenerateSpanOfClass("Enchantment", "r_bold")
	));

	foreach idx in all_gems
	{
		GemInfo gem_info = all_gems[idx];
		item gem = gem_info.gem_item;

		int in_inventory = gem.item_amount();
		int in_closet = gem.closet_amount();
		int in_storage = gem.storage_amount();
		int total = in_inventory + in_closet + in_storage;

		if (total > 0) continue; // Skip gems we have

		string gem_name = gem.to_string();
		if (gem_info.category == "IOTM")
			gem_name = HTMLGenerateSpanFont(gem_name, "blue");

		all_gems_table.listAppend(listMake(gem_name, gem_info.enchantment));
	}

	tooltip_text.append(HTMLGenerateSimpleTableLines(all_gems_table));

	string gem_reference = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class") + "View unowned gems", "r_tooltip_outer_class");
	description.listAppend(gem_reference);

	string title = "Eternity Codpiece";

	// Check if we have any IOTM gems
	boolean has_iotm_gems = false;
	foreach idx in all_gems
	{
		if (all_gems[idx].category == "IOTM" && all_gems[idx].gem_item.available_amount() > 0)
		{
			has_iotm_gems = true;
			break;
		}
	}

	if (has_iotm_gems)
		title += " " + HTMLGenerateSpanFont("(IOTM gems available)", "blue");

	resource_entries.listAppend(ChecklistEntryMake(12067, "__item the eternity codpiece", url, ChecklistSubentryMake(title, "", description), 5));
}
