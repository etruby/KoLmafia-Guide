RegisterResourceGenerationFunction("IOTMLegendarySealClubbingClubGenerateResource");
void IOTMLegendarySealClubbingClubGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!$item[Legendary Seal-Clubbing Club].have()) return;
	if (!$item[Legendary Seal-Clubbing Club].can_equip()) return;
	if (!$item[Legendary Seal-Clubbing Club].is_unrestricted()) return;

	// Check remaining uses for each skill (11 uses per day each)
	int battlefield_remaining = clampi(5 - get_property_int("_clubEmBattlefieldUsed"), 0, 5);
	int next_week_remaining = clampi(5 - get_property_int("_clubEmNextWeekUsed"), 0, 5);
	int time_remaining = clampi(5 - get_property_int("_clubEmTimeUsed"), 0, 5);

	// Only show if there are skills remaining
	if (battlefield_remaining == 0 && next_week_remaining == 0 && time_remaining == 0) return;

	string url = "skillz.php";
	boolean is_equipped = $item[Legendary Seal-Clubbing Club].equipped();

	if (!is_equipped)
	{
		url = generateEquipmentLink($item[Legendary Seal-Clubbing Club]);
	}

	string [int] description;

	// Add skill descriptions for available skills
	if (battlefield_remaining > 0)
	{
		description.listAppend("<strong>Club 'Em Across the Battlefield</strong> (" + battlefield_remaining + "/5):|Instakill + rolls drops against a monster in your last zone.|Preserves meat and items.");
	}

	if (next_week_remaining > 0)
	{
		description.listAppend("<strong>Club 'Em Into Next Week</strong> (" + next_week_remaining + "/5):|Instakill + wandering monster in 7 turns.|Preserves meat and items.");
	}

	if (time_remaining > 0)
	{
		description.listAppend("<strong>Club 'Em Back in Time</strong> (" + time_remaining + "/5):|Free kill. Destroys meat and items!");
	}

	if (!is_equipped)
	{
		description.listAppend("Equip first to use these skills.");
	}

	int total_remaining = battlefield_remaining + next_week_remaining + time_remaining;
	string title = pluralise(total_remaining, "Legendary Seal use", "Legendary Seal uses");

	resource_entries.listAppend(ChecklistEntryMake(485, "__item Legendary Seal-Clubbing Club", url, ChecklistSubentryMake(title, "", description), 2));
}
