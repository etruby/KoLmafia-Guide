
// Bat Wings (October 2024 IOTM)
// Back item with combat skills and underground zone bonuses
// Skills: Swoop like a Bat (11/day enhanced pickpocket), Summon Cauldron of Bats (11/day damage),
//         Rest upside down (11/day 1000 HP/MP restore)
// Passives: +5 all stats, +100% init, +50% food drops, find fruit (~20% combats)
// Underground bonuses: Free fights (5/day), auto-sonar in bat zones, reduced airship delay (20 instead of 25)
// Bridge crossing at 25/25 instead of 30/30

boolean batWingsIsAvailable()
{
	if (!$item[bat wings].is_unrestricted()) return false;
	if ($item[bat wings].available_amount() > 0) return true;
	// Check if any bat wings properties have been set
	if (get_property_boolean("batWingsBatHoleEntrance")) return true;
	if (get_property_boolean("batWingsBatratBurrow")) return true;
	if (get_property_boolean("batWingsBeanbatChamber")) return true;
	if (get_property_boolean("batWingsGuanoJunction")) return true;
	if (get_property_int("_batWingsSwoopUsed") > 0) return true;
	if (get_property_int("_batWingsRestUsed") > 0) return true;
	if (get_property_int("_batWingsCauldronUsed") > 0) return true;
	if (get_property_int("_batWingsFreeFights") > 0) return true;
	return false;
}

boolean batWingsIsEquipped()
{
	return $item[bat wings].equipped_amount() > 0;
}

RegisterResourceGenerationFunction("IOTMBatWingsGenerateResource");
void IOTMBatWingsGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!batWingsIsAvailable()) return;

	string [int] description;
	string url = "inventory.php?which=2";

	// Daily skill usage
	int swoop_used = get_property_int("_batWingsSwoopUsed");
	int swoop_remaining = MAX(0, 11 - swoop_used);
	int cauldron_used = get_property_int("_batWingsCauldronUsed");
	int cauldron_remaining = MAX(0, 11 - cauldron_used);
	int rest_used = get_property_int("_batWingsRestUsed");
	int rest_remaining = MAX(0, 11 - rest_used);
	int free_fights_used = get_property_int("_batWingsFreeFights");
	int free_fights_remaining = MAX(0, 5 - free_fights_used);

	// Track remaining resources
	string [int] resources;

	if (swoop_remaining > 0)
		resources.listAppend(swoop_remaining + " Swoop (enhanced pickpocket)");
	if (rest_remaining > 0)
		resources.listAppend(rest_remaining + " Rest (1000 HP/MP)");
	if (cauldron_remaining > 0)
		resources.listAppend(cauldron_remaining + " Cauldron (damage)");
	if (free_fights_remaining > 0)
		resources.listAppend(free_fights_remaining + " free underground fights");

	if (resources.count() == 0)
	{
		// All resources used today
		return;
	}

	description.listAppend("Daily uses remaining:|*" + resources.listJoinComponents("|*"));

	// Passive bonuses reminder
	if (!batWingsIsEquipped())
	{
		description.listAppend("Equip for +100% init, +50% food drops, +5 all stats.");
	}

	// Show underground zone bonuses if relevant
	boolean in_bat_quest = __quest_state["Level 4"].in_progress;
	if (in_bat_quest && free_fights_remaining > 0)
	{
		description.listAppend("Underground zones grant free fights and bonus drops.");
	}

	string title = "Bat Wings";
	if (swoop_remaining + rest_remaining + cauldron_remaining + free_fights_remaining > 0)
	{
		int total_uses = swoop_remaining + rest_remaining + cauldron_remaining + free_fights_remaining;
		title = "Bat Wings (" + total_uses + " uses)";
	}

	// Item ID for bat wings is 11652
	resource_entries.listAppend(ChecklistEntryMake(11652, "__item bat wings", url, ChecklistSubentryMake(title, "", description), 8));
}

RegisterTaskGenerationFunction("IOTMBatWingsGenerateTasks");
void IOTMBatWingsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!batWingsIsAvailable()) return;
	if (!__misc_state["in run"]) return;

	// Check for quest-specific advice

	// 1. Bat Hole Quest (Level 4) - Free sonar bonus
	if (__quest_state["Level 4"].in_progress)
	{
		int areas_unlocked = __quest_state["Level 4"].state_int["areas unlocked"];

		// Bat wings provide automatic sonar in Guano Junction and Ratbat Burrow
		// which helps unlock the Beanbat Chamber faster
		if (areas_unlocked < 2 && !$location[the beanbat chamber].locationAvailable())
		{
			if (!batWingsIsEquipped())
			{
				string [int] description;
				description.listAppend("Equip bat wings to get automatic sonar in Guano Junction and Batrat Burrow.");
				description.listAppend("This unlocks the Beanbat Chamber without needing sonar-in-a-biscuits.");

				optional_task_entries.listAppend(ChecklistEntryMake(11652, "__item bat wings", "inventory.php?which=2",
					ChecklistSubentryMake("Equip bat wings for Bat Hole", "", description), 8));
			}
		}
	}

	// 2. Airship Quest (Level 10) - Reduced delay
	// Only show this if:
	// - Beanstalk is grown but still doing airship
	// - Player hasn't been informed about the reduced delay
	if (__quest_state["Level 10"].in_progress && __quest_state["Level 10"].state_boolean["beanstalk grown"])
	{
		int turns_spent = $location[the penultimate fantasy airship].turns_spent;
		int sock_and_immateria_count = $items[Model airship,Plastic Wrap Immateria,Gauze Immateria,Tin Foil Immateria,Tissue Paper Immateria,S.O.C.K.].available_amount();

		// Only relevant if they haven't finished the airship
		if ($item[s.o.c.k.].available_amount() == 0 && turns_spent >= 0 && turns_spent < 20)
		{
			// Bat wings reduce delay from 25 to 20 turns
			if (batWingsIsEquipped())
			{
				// Player has wings equipped, just note the reduced delay
				// This is informational and handled by showing different delay in the Level 10 quest
			}
			else
			{
				// Suggest equipping for reduced delay
				string [int] description;
				description.listAppend("Equip bat wings for reduced airship delay (20 turns instead of 25).");
				description.listAppend("NCs that grant Immateria or SOCK appear after sufficient zone time.");

				optional_task_entries.listAppend(ChecklistEntryMake(11652, "__item bat wings", "inventory.php?which=2",
					ChecklistSubentryMake("Equip bat wings for Airship", "", description), 9));
			}
		}
	}

	// 3. Orc Chasm Bridge (Level 9) - Can cross at 25/25
	// This is already handled in Level 9.ash at line 535-538
	// We just add a reminder if they're close to 25/25 but not 30/30
	if (__quest_state["Level 9"].in_progress && __quest_state["Level 9"].mafia_internal_step == 1)
	{
		int fasteners_needed = __quest_state["Level 9"].state_int["bridge fasteners needed"];
		int lumber_needed = __quest_state["Level 9"].state_int["bridge lumber needed"];
		int bridge_progress = get_property_int("chasmBridgeProgress");

		// If they're at 25+ progress but less than 30 (so 25-29)
		// Bat wings lets them fly across
		if (bridge_progress >= 25 && (fasteners_needed > 0 || lumber_needed > 0))
		{
			if (!batWingsIsEquipped())
			{
				string [int] description;
				description.listAppend("You have 25+ bridge progress - equip bat wings to fly across!");
				description.listAppend("No need to collect the remaining materials.");

				task_entries.listAppend(ChecklistEntryMake(11652, "__item bat wings", "inventory.php?which=2",
					ChecklistSubentryMake("Fly across Orc Chasm", "", description), 5));
			}
		}
	}
}
