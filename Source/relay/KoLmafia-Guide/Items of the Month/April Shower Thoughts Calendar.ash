// April Shower Thoughts Calendar (April 2025)
// An off-hand shield that grants globs of wet paper daily and enhances class skills
//
// Properties:
// - _aprilShowerGlobsCollected: boolean, whether daily globs were collected
// - _aprilShowerDiscoNap: int, times Disco Nap was enhanced (0-5, gives 100/80/60/40/20 MP)
// - _aprilShowerNorthernExplosion: boolean, whether yellow ray was used
// - _aprilShowerSimmer: boolean, whether free Simmer was used
//
// Skill Boosts (while equipped):
// - Seal Clubber: Seal Clubbing Frenzy (+buff), Lunging Thrust-Smack (stagger), Northern Explosion (yellow ray!)
// - Turtle Tamer: Patience of the Tortoise (+buff), Shieldbutt (random effect), Empathy of the Newt (+fam weight)
// - Pastamancer: Manicotti Meditation (+buff), Lasagna Bandages (+100% heal), Leash of Linguini (+duration)
// - Sauceror: Sauce Contemplation (+buff), Wave of Sauce (+delevel), Simmer (first cast free!)
// - Disco Bandit: Disco Aerobics (+buff), Disco Nap (+MP 5x/day), Pickpocket w/Sensitive Fingers (+10%)
// - Accordion Thief: Moxie of the Mariachi (+buff), Accordion Bash (+stun), Pickpocket w/Sticky Fingers (+meat)

// Skills that get boosted, organized by class and effect type
// Format: skill -> description of boost
string [skill] __aprilShowerBuffSkills;
string [skill] __aprilShowerCombatSkills;
string [skill] __aprilShowerDailySkills;

void initAprilShowerSkills()
{
	// Buff skills (always grant extra effects when cast with shield equipped)
	__aprilShowerBuffSkills[$skill[Seal Clubbing Frenzy]] = "+5 turns Slippery as a Seal (+50% init, +10 mox)";
	__aprilShowerBuffSkills[$skill[Patience of the Tortoise]] = "+5 turns Strength of the Tortoise (+10 mus, MP regen)";
	__aprilShowerBuffSkills[$skill[Manicotti Meditation]] = "+5 turns Tubes of Universal Meat (+30% meat, +10 myst)";
	__aprilShowerBuffSkills[$skill[Sauce Contemplation]] = "+5 turns Lubricating Sauce (+15% item, +10 mox)";
	__aprilShowerBuffSkills[$skill[Disco Aerobics]] = "+5 turns Disco over Matter (+10 mus, HP regen)";
	__aprilShowerBuffSkills[$skill[Moxie of the Mariachi]] = "+5 turns Mariachi Moisture (+10% crit, +10 myst)";
	__aprilShowerBuffSkills[$skill[Empathy of the Newt]] = "Grants Thoughtful Empathy (+8 fam weight) instead";
	__aprilShowerBuffSkills[$skill[Leash of Linguini]] = "+5 turns to buff duration";

	// Combat skills (enhance combat abilities)
	__aprilShowerCombatSkills[$skill[Lunging Thrust-Smack]] = "First cast staggers for 1 turn";
	__aprilShowerCombatSkills[$skill[Shieldbutt]] = "Every 5 casts grants random 5-turn effect";
	__aprilShowerCombatSkills[$skill[Lasagna Bandages]] = "+100% healing";
	__aprilShowerCombatSkills[$skill[Wave of Sauce]] = "+150% delevel";
	__aprilShowerCombatSkills[$skill[Accordion Bash]] = "+2 rounds of stun";

	// Daily limited skills (tracked by properties)
	__aprilShowerDailySkills[$skill[Northern Explosion]] = "First cast is a FREE yellow ray instakill!";
	__aprilShowerDailySkills[$skill[Simmer]] = "First cast is free (no adventure cost)";
	__aprilShowerDailySkills[$skill[Disco Nap]] = "First 5 uses restore extra MP (100/80/60/40/20)";
}

initAprilShowerSkills();

RegisterResourceGenerationFunction("IOTMAprilShowerGenerateResource");
void IOTMAprilShowerGenerateResource(ChecklistEntry [int] resource_entries)
{
	item shower_shield = $item[April Shower Thoughts shield];
	item shower_package = $item[Packaged April Shower Thoughts Calendar];

	// Check if usable - they need either the shield or the unopened package
	if (!shower_shield.is_unrestricted()) return;
	if (shower_shield.available_amount() == 0 && shower_package.available_amount() == 0) return;

	// If they have the package but not the shield, remind them to open it
	if (shower_shield.available_amount() == 0 && shower_package.available_amount() > 0)
	{
		string [int] description;
		description.listAppend("Use the package to get your April Shower Thoughts shield!");
		resource_entries.listAppend(ChecklistEntryMake(12025, "__item Packaged April Shower Thoughts Calendar",
			"inventory.php?ftext=packaged+april",
			ChecklistSubentryMake("Open April Shower Thoughts Calendar", "", description), -11));
		return;
	}

	// Get property values
	boolean globs_collected = get_property_boolean("_aprilShowerGlobsCollected");
	int disco_nap_uses = get_property_int("_aprilShowerDiscoNap");
	boolean northern_explosion_used = get_property_boolean("_aprilShowerNorthernExplosion");
	boolean simmer_used = get_property_boolean("_aprilShowerSimmer");

	// Count globs of wet paper
	item wet_paper = $item[glob of wet paper];
	int glob_count = wet_paper.available_amount();

	string [int] description;
	string [int] modifiers;

	// === Daily Shower (Glob Collection) ===
	if (!globs_collected)
	{
		description.listAppend(HTMLGenerateSpanFont("Take a shower to collect 2-4 globs of wet paper!", "red"));
	}

	// === Glob Count ===
	if (glob_count > 0)
	{
		description.listAppend(pluralise(glob_count, "glob", "globs") + " of wet paper available.");
	}
	else if (globs_collected)
	{
		description.listAppend("No globs of wet paper. Collect more tomorrow!");
	}

	// === Daily Skill Abilities ===
	// Northern Explosion (Seal Clubber yellow ray)
	if ($skill[Northern Explosion].skill_is_usable() && !northern_explosion_used)
	{
		description.listAppend(HTMLGenerateSpanOfClass("Yellow ray available!", "r_bold") + " Northern Explosion is an instakill.");
		modifiers.listAppend("yellow ray");
	}

	// Simmer (Sauceror free cast)
	if ($skill[Simmer].skill_is_usable() && !simmer_used)
	{
		description.listAppend("Free Simmer cast available (no adventure cost).");
		modifiers.listAppend("free simmer");
	}

	// Disco Nap (Disco Bandit MP)
	if ($skill[Disco Nap].skill_is_usable() && disco_nap_uses < 5)
	{
		int remaining_uses = 5 - disco_nap_uses;
		// Calculate remaining MP: 100, 80, 60, 40, 20 for uses 0-4
		int remaining_mp = 0;
		for i from disco_nap_uses to 4
		{
			remaining_mp += (100 - i * 20);
		}
		description.listAppend(remaining_uses + " enhanced Disco Nap" + (remaining_uses != 1 ? "s" : "") + " left (" + remaining_mp + " extra MP).");
		modifiers.listAppend(remaining_mp + " MP");
	}

	// === Boosted Skills List ===
	string [int] boosted_skills;

	// Check buff skills
	foreach sk in __aprilShowerBuffSkills
	{
		if (sk.skill_is_usable())
		{
			boosted_skills.listAppend(sk.to_string() + ": " + __aprilShowerBuffSkills[sk]);
		}
	}

	// Check combat skills
	foreach sk in __aprilShowerCombatSkills
	{
		if (sk.skill_is_usable())
		{
			boosted_skills.listAppend(sk.to_string() + ": " + __aprilShowerCombatSkills[sk]);
		}
	}

	// Add boosted skills info if any
	if (boosted_skills.count() > 0)
	{
		description.listAppend("Skills boosted while equipped: " + boosted_skills.listJoinComponents(", ") + ".");
	}

	// Equip reminder if not equipped and they have useful things to do
	if (shower_shield.equipped_amount() == 0 && boosted_skills.count() > 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Equip the shield to boost your skills!", "red"));
	}

	// Don't show if nothing to report
	if (description.count() == 0) return;

	// Build title
	string title;
	if (!globs_collected)
		title = "Take a shower!";
	else if (glob_count > 0)
		title = "April Shower: " + pluralise(glob_count, "glob", "globs");
	else
		title = "April Shower Thoughts";

	// URL: link to the shield in inventory, or to the shower action
	string url = "inventory.php?ftext=april+shower";

	// Priority: higher if shower not taken
	int priority = globs_collected ? 5 : -5;

	ChecklistEntry entry = ChecklistEntryMake(12025, "__item April Shower Thoughts shield", url,
		ChecklistSubentryMake(title, modifiers.listJoinComponents(", "), description), priority);

	// Short description for resource bar
	if (!globs_collected)
		entry.ChecklistEntrySetShortDescription("shower!");
	else if (glob_count > 0)
		entry.ChecklistEntrySetShortDescription(glob_count + " globs");
	else if (modifiers.count() > 0)
		entry.ChecklistEntrySetShortDescription(modifiers[0]);

	resource_entries.listAppend(entry);
}
