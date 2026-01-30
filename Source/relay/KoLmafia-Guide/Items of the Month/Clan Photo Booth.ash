
RegisterResourceGenerationFunction("IOTMClanPhotoBoothGenerateResource");
void IOTMClanPhotoBoothGenerateResource(ChecklistEntry [int] resource_entries)
{
    // Clan Photo Booth is a VIP Lounge furnishing
    // 3 photos (effects) per day, 3 props (equipment) per day

    if (!__misc_state["VIP available"])
        return;

    int photos_remaining = MAX(3 - get_property_int("_photoBoothEffects"), 0);
    int props_remaining = MAX(3 - get_property_int("_photoBoothEquipment"), 0);

    // Only show if there are resources remaining
    if (photos_remaining == 0 && props_remaining == 0)
        return;

    ChecklistEntry entry = ChecklistEntryMake(760);
    entry.image_lookup_name = "__item photo booth supply list";
    entry.url = "clan_viplounge.php?action=photobooth";

    if (photos_remaining > 0)
    {
        string [int] description;
        description.listAppend("50-turn buff (Wild and Westy!, Towering Muscles, or Spaced Out).");
        entry.subentries.listAppend(ChecklistSubentryMake(pluralise(photos_remaining, "photo", "photos") + " remaining", "", description));
    }

    if (props_remaining > 0)
    {
        string [int] description;
        description.listAppend("Borrow equipment for the day.");
        entry.subentries.listAppend(ChecklistSubentryMake(pluralise(props_remaining, "prop", "props") + " remaining", "", description));
    }

    entry.ChecklistEntrySetAbridgedHeader("Clan Photo Booth");
    resource_entries.listAppend(entry);
}
