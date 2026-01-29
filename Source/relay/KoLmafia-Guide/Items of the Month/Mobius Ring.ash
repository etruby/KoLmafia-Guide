// Möbius Ring (August 2025)
// An accessory that triggers "Time is a Möbius Strip" non-combats at intervals
// Also spawns Time Cop free fights based on Paradoxicity level
//
// Properties:
// - _lastMobiusStripTurn: Turn of last "Time is a Möbius Strip" NC
// - _mobiusStripEncounters: Total encounters this ascension
//
// NC Schedule (turns after previous encounter):
// 1st: 4 turns, 2nd: 7, 3rd: 13, 4th: 19, 5th: 25, 6th: 31, 7th: 41
// 8th-11th: 41 turns each
// 12th-16th: 51 turns each
// 17th+: 76 turns each

int [int] __mobius_nc_intervals;
__mobius_nc_intervals[0] = 4;   // 1st NC after 4 turns
__mobius_nc_intervals[1] = 7;   // 2nd NC
__mobius_nc_intervals[2] = 13;  // 3rd NC
__mobius_nc_intervals[3] = 19;  // 4th NC
__mobius_nc_intervals[4] = 25;  // 5th NC
__mobius_nc_intervals[5] = 31;  // 6th NC
__mobius_nc_intervals[6] = 41;  // 7th NC

int MobiusGetNCInterval(int encounters)
{
	// Use the table for encounters 0-6
	if (encounters < __mobius_nc_intervals.count())
		return __mobius_nc_intervals[encounters];

	// 8th-11th (encounters 7-10): 41 turns each
	if (encounters <= 10)
		return 41;

	// 12th-16th (encounters 11-15): 51 turns each
	if (encounters <= 15)
		return 51;

	// 17th+ (encounters 16+): 76 turns each
	return 76;
}

RegisterResourceGenerationFunction("IOTMMobiusRingGenerateResource");
void IOTMMobiusRingGenerateResource(ChecklistEntry [int] resource_entries)
{
	item mobius_ring = $item[M&ouml;bius ring];

	// Check if the Möbius ring is usable
	if (!mobius_ring.is_unrestricted()) return;
	if (mobius_ring.available_amount() == 0) return;

	// Get property values
	int last_nc_turn = get_property_int("_lastMobiusStripTurn");
	int encounters = get_property_int("_mobiusStripEncounters");
	int current_turn = total_turns_played();

	// Calculate turns until next NC
	int interval = MobiusGetNCInterval(encounters);
	int turns_since_last = current_turn - last_nc_turn;
	int turns_until_nc = max(0, interval - turns_since_last);

	// Build description
	string [int] description;

	// NC countdown
	string nc_status;
	if (turns_until_nc == 0)
	{
		nc_status = HTMLGenerateSpanOfClass("NC available now!", "r_bold");
		description.listAppend(nc_status);
		description.listAppend("\"Time is a Möbius Strip\" NC is ready to appear.");
	}
	else
	{
		nc_status = pluralise(turns_until_nc, "turn", "turns") + " until next NC";
		description.listAppend(nc_status);
	}

	// Encounters so far
	if (encounters > 0)
		description.listAppend(pluralise(encounters, "NC encounter", "NC encounters") + " so far today.");

	// Next interval info
	int next_interval = MobiusGetNCInterval(encounters + 1);
	if (next_interval != interval)
		description.listAppend("After next NC: " + next_interval + " turn interval.");
	else
		description.listAppend("NC interval: " + interval + " turns.");

	// Equip reminder if not equipped
	if (mobius_ring.equipped_amount() == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Equip the Möbius ring to spawn encounters.", "red"));
	}

	// Build title
	string title;
	if (turns_until_nc == 0)
		title = "Möbius Strip NC ready";
	else
		title = "Möbius ring: " + pluralise(turns_until_nc, "turn", "turns") + " to NC";

	string url = "inventory.php?ftext=m%C3%B6bius";

	// Priority: higher when NC is ready
	int priority = (turns_until_nc == 0) ? -2 : 2;

	ChecklistEntry entry = ChecklistEntryMake(12024, "__item Möbius ring", url, ChecklistSubentryMake(title, "", description), priority);

	// Short description for resource bar
	if (turns_until_nc == 0)
		entry.ChecklistEntrySetShortDescription("now");
	else
		entry.ChecklistEntrySetShortDescription(turns_until_nc + " turns");

	resource_entries.listAppend(entry);
}
