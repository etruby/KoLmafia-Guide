void S8bitRealmGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (__quest_state["Level 13"].state_boolean["digital key used"] || $item[digital key].available_amount() > 0)
    {
        return;
    }

    string [int] description;

    if ("8BitScore".get_property_int() >= 10000)
    {
        description.listAppend("Buy the key from the Treasure House.");
        optional_task_entries.listAppend(ChecklistEntryMake(267, "__item digital key", "place.php?whichplace=8bit&action=8treasure", ChecklistSubentryMake("Get 8-Bit Points", "", description)));
        return;
    }

    switch("8BitColor".get_property())
    {
        case "red":
            description.listAppend("The Fungus Plains, need at least 445.6% bonus Meat from Monsters for maximum bonus points, 150% for minimum.");
            description.listAppend("Current Meat Bonus: " + meat_drop_modifier());
            break;
        case "blue":
            description.listAppend("Megalo-City, need at least 595.6 Damage Absorption for maximum bonus points, 300 for minimum");
            description.listAppend("Current DA: " + raw_damage_absorption());
            break;
        case "green":
            description.listAppend("Hero's Field, need at least 395.6% bonus Items from Monsters for maximum bonus points, 100% for minimum");
            description.listAppend("Current Item Bonus: " + item_drop_modifier());
            break;
        default:
            description.listAppend("Vanya's Castle, need at least 595.6% Combat Initiative for maximum bonus points, 300% for minimum");
            description.listAppend("Current Initiative: " + initiative_modifier());
            break;
    }

    optional_task_entries.listAppend(ChecklistEntryMake(267, "__item digital key", "place.php?whichplace=8bit", ChecklistSubentryMake("Get 8-Bit Points", "", description)));
}
