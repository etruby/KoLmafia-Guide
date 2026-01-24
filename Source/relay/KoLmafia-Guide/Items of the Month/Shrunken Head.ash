
RegisterResourceGenerationFunction("IOTMShrunkenHeadGenerateResource");
void IOTMShrunkenHeadGenerateResource(ChecklistEntry [int] resource_entries)
{
	item shrunken_head = $item[shrunken head];

	// Check if the shrunken head is usable (standard restrictions and ownership)
	if (!shrunken_head.is_unrestricted()) return;
	if (!get_property_boolean("hasShrunkenHead") && shrunken_head.available_amount() == 0) return;

	string [int] description;
	string url = "inventory.php?which=2";

	string zombie_monster = get_property("shrunkenHeadZombieMonster");

	if (zombie_monster == "")
	{
		// No zombie currently active
		description.listAppend("Reanimate a defeated foe to gain abilities based on the monster.");
		resource_entries.listAppend(ChecklistEntryMake(12019, "__item shrunken head", url, ChecklistSubentryMake("Shrunken head available", "", description), 8));
	}
	else
	{
		// Zombie is active, show current abilities
		string abilities = get_property("shrunkenHeadZombieAbilities");
		int zombie_hp = get_property_int("shrunkenHeadZombieHP");

		description.listAppend("Current zombie: " + zombie_monster);
		if (zombie_hp > 0)
			description.listAppend("Zombie HP: " + zombie_hp);

		if (abilities != "")
		{
			// Parse abilities into a cleaner format
			string [int] ability_list = abilities.split_string(", ");
			if (ability_list.count() > 0)
			{
				description.listAppend("Abilities:|*" + ability_list.listJoinComponents("|*"));
			}
		}

		resource_entries.listAppend(ChecklistEntryMake(12019, "__item shrunken head", url, ChecklistSubentryMake("Shrunken head zombie", "", description), 8));
	}
}
