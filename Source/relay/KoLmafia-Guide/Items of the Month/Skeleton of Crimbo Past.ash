
RegisterResourceGenerationFunction("IOTMSkeletonOfCrimboPastGenerateResource");
void IOTMSkeletonOfCrimboPastGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!$familiar[Skeleton of Crimbo Past].familiar_is_usable()) return;

	int knucklebones_acquired = get_property_int("_knuckleboneDrops");
	int knucklebones_remaining = 100 - knucklebones_acquired;

	// Hide if all knucklebones have been acquired for the day
	if (knucklebones_remaining <= 0) return;

	string [int] description;
	string url = "main.php?talktosocp=1&pwd=" + my_hash();

	description.listAppend("Knucklebones drop in combat and from resting (5/day from resting).");
	description.listAppend("Spend knucklebones at Visiting the Skeleton of Crimbo Past for consumables.");

	// Suggest optimal zones for farming skeletons
	if (__misc_state["in run"])
	{
		string [int] zone_suggestions;

		// The Skeleton Store is always 100%
		zone_suggestions.listAppend("The Skeleton Store (100% skeletons)");

		// Defiled Nook during cyrpt quest
		if (!__quest_state["Level 7"].finished && get_property_int("cyrptNookEvilness") > 0)
			zone_suggestions.listAppend("The Defiled Nook (100% skeletons)");

		if (zone_suggestions.count() > 0)
			description.listAppend("Best zones for skeletons:|*" + zone_suggestions.listJoinComponents("|*"));
	}

	resource_entries.listAppend(ChecklistEntryMake(12051, "__familiar Skeleton of Crimbo Past", url, ChecklistSubentryMake(knucklebones_acquired + "/100 knucklebones", "", description), 8));
}
