
// Allied Radio Backpack (Skeleton War event item)
// A back item that provides daily supply drops via typed commands
// 3 drops per day, plus special once-per-day options

RegisterResourceGenerationFunction("IOTMAlliedRadioBackpackGenerateResource");
void IOTMAlliedRadioBackpackGenerateResource(ChecklistEntry [int] resource_entries)
{
	item backpack = $item[Allied Radio Backpack];

	// Check if the backpack is available and usable
	if (!backpack.is_unrestricted()) return;
	if (backpack.available_amount() == 0) return;

	int drops_used = get_property_int("_alliedRadioDropsUsed");
	int drops_remaining = clampi(3 - drops_used, 0, 3);
	boolean materiel_intel_used = get_property_boolean("_alliedRadioMaterielIntel");
	boolean wildsun_boon_used = get_property_boolean("_alliedRadioWildsunBoon");

	// Hide if all resources exhausted
	if (drops_remaining <= 0 && materiel_intel_used) return;

	string [int] description;

	// Highlight most valuable options for speedrunning
	if (drops_remaining > 0)
	{
		string [int] recommended;

		// Sniper Support is the main speedrun value - forced non-combats
		recommended.listAppend(HTMLGenerateSpanOfClass("SNIPER SUPPORT", "r_bold") + ": Forces next adventure to be a non-combat");

		// Material Intel is good but once per day (separate from 3 drops)
		if (!materiel_intel_used)
			recommended.listAppend(HTMLGenerateSpanOfClass("MATERIAL INTEL", "r_bold") + ": +100% item drop (10 turns, once/day)");

		// Wildsun Boon is good early in the day
		if (!wildsun_boon_used)
			recommended.listAppend(HTMLGenerateSpanOfClass("WILDSUN BOON", "r_bold") + ": +3 prismatic res, +5 fam weight, +75% init, +50% wpn/spell (100 turns)");

		if (recommended.count() > 0)
			description.listAppend("Recommended:|*" + recommended.listJoinComponents("|*"));

		// Other options
		string [int] other_options;
		other_options.listAppend("ELLIPSOIDTINE: +50 HP, +25 MP, 5-10 MP regen, removes 1 debuff (30 turns)");
		other_options.listAppend("ORDNANCE: skeleton war grenade (200-300 damage combat item)");
		other_options.listAppend("RATIONS: Skeleton War rations (1-fullness epic food)");
		other_options.listAppend("FUEL: skeleton war fuel can (1-drunk epic booze)");
		other_options.listAppend("SALARY: 15 Chroner");
		other_options.listAppend("RADIO: tradeable sneak charge");

		description.listAppend("Other options:|*" + other_options.listJoinComponents("|*"));
	}
	else if (!materiel_intel_used)
	{
		// Out of drops but can still use materiel intel
		description.listAppend("Out of regular drops, but " + HTMLGenerateSpanOfClass("MATERIAL INTEL", "r_bold") + " still available (+100% item, 10 turns).");
	}

	string title;
	if (drops_remaining > 0)
		title = pluralise(drops_remaining, "Allied Radio drop", "Allied Radio drops");
	else
		title = "Allied Radio Backpack";

	// URL to request a drop - opens the backpack interface
	string url = "inventory.php?action=requestdrop&pwd=" + my_hash();

	// Higher priority if sniper support available for forced NC
	int priority = (drops_remaining > 0) ? 1 : 5;

	resource_entries.listAppend(ChecklistEntryMake(12052, "__item Allied Radio Backpack", url, ChecklistSubentryMake(title, "", description), priority).ChecklistEntrySetCategory("resources"));
}
