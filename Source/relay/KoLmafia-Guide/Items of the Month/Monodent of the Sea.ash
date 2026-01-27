
// Monodent of the Sea (September 2025)
// A 1-handed spear with scaling enchantments based on "tines" (T)
// Tines scale: min(10, floor(sqrt(constructs_killed)))
//
// Skills:
// - Lightning Bolt (11/day): Instakill + banish (only one monster at a time, toggles)
// - Summon a Wave (1/day): Flood a zone with +30% meat/items/init (requires Fishy)
// - Talk to Some Fish (unlimited): Transform monster into fish, resets per-fight flags
//
// Properties:
// - seadentConstructKills: Total constructs killed
// - seadentLevel: Current tine level (1-10)
// - _seadentLightningUsed: Daily Lightning Bolt uses (max 11)
// - _seadentWaveUsed: Whether Summon a Wave used today
// - _seadentWaveZone: Currently flooded zone

// Weapon names by tine level (constructs needed: level^2)
string [int] __seadent_names;
__seadent_names[1] = "Monodent";
__seadent_names[2] = "Bident";
__seadent_names[3] = "Trident";
__seadent_names[4] = "Quadent";
__seadent_names[5] = "Pentadent";
__seadent_names[6] = "Hexadent";
__seadent_names[7] = "Heptadent";
__seadent_names[8] = "Octodent";
__seadent_names[9] = "Nonadent";
__seadent_names[10] = "Decadent";

RegisterResourceGenerationFunction("IOTMMonodentGenerateResource");
void IOTMMonodentGenerateResource(ChecklistEntry [int] resource_entries)
{
	item monodent = $item[Monodent of the Sea];

	// Check if usable
	if (!monodent.is_unrestricted()) return;
	if (monodent.available_amount() == 0) return;

	// Get property values
	int lightning_used = get_property_int("_seadentLightningUsed");
	int lightning_remaining = 11 - lightning_used;
	boolean wave_used = get_property_boolean("_seadentWaveUsed");
	string flooded_zone = get_property("_seadentWaveZone");
	int construct_kills = get_property_int("seadentConstructKills");
	int tine_level = get_property_int("seadentLevel");

	// Calculate tines from construct kills (for display)
	// Formula: min(10, floor(sqrt(X)))
	int calculated_tines = min(10, square_root(construct_kills).floor());

	// Build description
	string [int] description;

	// Tine level info
	string tine_info = "Tine level: " + tine_level;
	if (tine_level < 10)
	{
		// Calculate constructs needed for next level
		int next_level = tine_level + 1;
		int constructs_needed = next_level * next_level; // inverse of sqrt
		int more_needed = constructs_needed - construct_kills;
		if (more_needed > 0)
			tine_info += " (need " + more_needed + " more construct kills for level " + next_level + ")";
	}
	else
	{
		tine_info += " (max)";
	}
	description.listAppend(tine_info);

	// Track what's available
	string [int] available_skills;
	boolean has_resources = false;

	// Lightning Bolt (11/day)
	if (lightning_remaining > 0)
	{
		has_resources = true;
		string lightning_desc = "<strong>Lightning Bolt</strong>: " + lightning_remaining + "/11 remaining";
		lightning_desc += "|*Instakill + banish for rest of day (only 1 monster at a time)";
		available_skills.listAppend(lightning_desc);
	}

	// Summon a Wave (1/day)
	if (!wave_used)
	{
		has_resources = true;
		string wave_desc = "<strong>Summon a Wave</strong>: Available";
		wave_desc += "|*Flood a zone for +30% meat/items/init (requires Fishy effect)";
		available_skills.listAppend(wave_desc);
	}
	else if (flooded_zone != "")
	{
		description.listAppend("Flooded zone: " + flooded_zone + " (+30% meat/items/init)");
	}

	// Talk to Some Fish is unlimited so always mention it
	description.listAppend("<strong>Talk to Some Fish</strong>: Transform monsters to fish (resets per-fight flags)");

	// Add available skills
	if (available_skills.count() > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass("Available skills:", "r_bold"));
		foreach idx in available_skills
		{
			description.listAppend(available_skills[idx]);
		}
	}

	// Synergies
	string [int] synergies;

	// CyberRealm synergy - construct kills in free-fight zones
	if ($item[CyberRealm keycode].is_unrestricted() && $item[CyberRealm keycode].available_amount() > 0 && tine_level < 10)
	{
		synergies.listAppend("CyberRealm constructs can raise tine level");
	}

	// Blood Cubic Zirconia synergy - fish provide substats
	if ($item[blood cubic zirconia].is_unrestricted() && $item[blood cubic zirconia].available_amount() > 0)
	{
		synergies.listAppend("Talk to Some Fish provides substats for BCZ skills");
	}

	if (synergies.count() > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass("Synergies:", "r_bold") + " " + synergies.listJoinComponents(", "));
	}

	// Title and priority
	string weapon_name = __seadent_names[tine_level];
	if (weapon_name == "")
		weapon_name = "Monodent"; // fallback

	string title;
	if (has_resources)
	{
		string [int] resources;
		if (lightning_remaining > 0)
			resources.listAppend(lightning_remaining + " Lightning Bolt");
		if (!wave_used)
			resources.listAppend("Wave");
		title = weapon_name + ": " + resources.listJoinComponents(", ");
	}
	else
	{
		title = weapon_name + " of the Sea";
	}

	string url = "inventory.php?ftext=monodent";

	// Priority: higher if skills available
	int priority = has_resources ? 1 : 8;

	resource_entries.listAppend(ChecklistEntryMake(12021, "__item Monodent of the Sea", url, ChecklistSubentryMake(title, "", description), priority));
}
