
// Blood Cubic Zirconia (October 2025)
// An accessory that grants 9 skills using substats as a resource
// Skills are grouped by stat type: Muscle, Mysticality, Moxie
// Costs scale: 11, 23, 37, 110, 230, 370, 1100, 2300, 3700, 11000...
//
// NOTE: KoLmafia doesn't properly track gems socketed in The Eternity Codpiece
// as being in inventory or equipped. Skills still work when socketed, but
// this implementation may not detect the BCZ if it's only in the Codpiece.

int [int] __bcz_cost_table;
__bcz_cost_table[0] = 11;
__bcz_cost_table[1] = 23;
__bcz_cost_table[2] = 37;
__bcz_cost_table[3] = 110;
__bcz_cost_table[4] = 230;
__bcz_cost_table[5] = 370;
__bcz_cost_table[6] = 1100;
__bcz_cost_table[7] = 2300;
__bcz_cost_table[8] = 3700;
__bcz_cost_table[9] = 11000;

int BCZGetNextCost(int casts_made)
{
	if (casts_made >= __bcz_cost_table.count())
		return 999999; // Effectively unlimited
	return __bcz_cost_table[casts_made];
}

// Helper to format large numbers nicely
string BCZFormatNumber(int n)
{
	if (n >= 1000)
		return (n / 1000) + "," + (n % 1000 < 100 ? "0" : "") + (n % 1000 < 10 ? "0" : "") + (n % 1000);
	return n.to_string();
}

RegisterResourceGenerationFunction("IOTMBloodCubicZirconiaGenerateResource");
void IOTMBloodCubicZirconiaGenerateResource(ChecklistEntry [int] resource_entries)
{
	item bcz = $item[blood cubic zirconia];

	// Check if the blood cubic zirconia is usable
	if (!bcz.is_unrestricted()) return;
	if (bcz.available_amount() == 0) return;

	// Get current substats
	int muscle_substats = my_basestat($stat[submuscle]);
	int myst_substats = my_basestat($stat[submysticality]);
	int moxie_substats = my_basestat($stat[submoxie]);

	// Define skill data: property name, display name, description, stat type
	record BCZSkill
	{
		string property_name;
		string display_name;
		string description;
		stat substat_type;
		boolean is_combat;
	};

	BCZSkill [int] skills;

	// Muscle skills
	skills[0] = new BCZSkill("_bczBloodGeyserCasts", "Blood Geyser", "30-turn stun", $stat[submuscle], true);
	skills[1] = new BCZSkill("_bczBloodBathCasts", "Blood Bath", "+5xLvl ML, +100% wpn dmg, +5% combat (30 turns)", $stat[submuscle], false);
	skills[2] = new BCZSkill("_bczBloodThinnerCasts", "Create Blood Thinner", "1-spleen item, +100 HP/+1000% HP (50 turns)", $stat[submuscle], false);

	// Mysticality skills
	skills[3] = new BCZSkill("_bczRefractedGazeCasts", "Refracted Gaze", "Get drops from all other monsters in zone", $stat[submysticality], true);
	skills[4] = new BCZSkill("_bczDialitupCasts", "Dial it up to 11", "+111% spell dmg, +111% myst (30 turns)", $stat[submysticality], false);
	skills[5] = new BCZSkill("_bczSpinalTapasCasts", "Prepare Spinal Tapas", "3.5 adv/full food, +300% myst (30 turns)", $stat[submysticality], false);

	// Moxie skills
	skills[6] = new BCZSkill("_bczSweatBulletsCasts", "Sweat Bullets", "Free kill!", $stat[submoxie], true);
	skills[7] = new BCZSkill("_bczPheromoneCocktailCasts", "Craft Pheromone Cocktail", "4 adv/drunk drink, all-day banish charge", $stat[submoxie], false);
	skills[8] = new BCZSkill("_bczSweatEquityCasts", "Sweat Equity", "+40% meat drop (30 turns)", $stat[submoxie], false);

	// Group skills by whether they're affordable
	string [int] affordable_muscle;
	string [int] affordable_myst;
	string [int] affordable_moxie;
	string [int] unaffordable;

	int total_affordable = 0;

	foreach idx in skills
	{
		BCZSkill s = skills[idx];
		int casts_made = get_property_int(s.property_name);
		int next_cost = BCZGetNextCost(casts_made);

		int current_substats;
		string stat_abbrev;
		if (s.substat_type == $stat[submuscle])
		{
			current_substats = muscle_substats;
			stat_abbrev = "Mus";
		}
		else if (s.substat_type == $stat[submysticality])
		{
			current_substats = myst_substats;
			stat_abbrev = "Mys";
		}
		else
		{
			current_substats = moxie_substats;
			stat_abbrev = "Mox";
		}

		boolean can_afford = (current_substats >= next_cost);

		string combat_tag = s.is_combat ? " [combat]" : "";
		string entry = "<strong>" + s.display_name + "</strong>" + combat_tag + ": " + s.description;
		entry += " (Cost: " + BCZFormatNumber(next_cost) + " " + stat_abbrev + ")";

		if (can_afford)
		{
			total_affordable++;
			if (s.substat_type == $stat[submuscle])
				affordable_muscle.listAppend(entry);
			else if (s.substat_type == $stat[submysticality])
				affordable_myst.listAppend(entry);
			else
				affordable_moxie.listAppend(entry);
		}
		else
		{
			entry += " [need " + BCZFormatNumber(next_cost - current_substats) + " more]";
			unaffordable.listAppend(entry);
		}
	}

	// Build description
	string [int] description;

	// Current substats summary
	description.listAppend("Substats: " + BCZFormatNumber(muscle_substats) + " Mus / " + BCZFormatNumber(myst_substats) + " Mys / " + BCZFormatNumber(moxie_substats) + " Mox");

	if (affordable_muscle.count() > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass("Muscle skills:", "r_bold") + "|*" + affordable_muscle.listJoinComponents("|*"));
	}

	if (affordable_myst.count() > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass("Mysticality skills:", "r_bold") + "|*" + affordable_myst.listJoinComponents("|*"));
	}

	if (affordable_moxie.count() > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass("Moxie skills:", "r_bold") + "|*" + affordable_moxie.listJoinComponents("|*"));
	}

	if (unaffordable.count() > 0 && total_affordable > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass("Not enough substats:", "r_future_option") + "|*" + unaffordable.listJoinComponents("|*"));
	}
	else if (total_affordable == 0)
	{
		description.listAppend("Not enough substats for any skills.");
		description.listAppend("Skills need:|*" + unaffordable.listJoinComponents("|*"));
	}

	string title;
	if (total_affordable > 0)
		title = pluralise(total_affordable, "BCZ skill", "BCZ skills") + " available";
	else
		title = "Blood Cubic Zirconia";

	string url = "skillz.php";

	// Priority: higher if skills available, lower if not
	int priority = (total_affordable > 0) ? 1 : 8;

	resource_entries.listAppend(ChecklistEntryMake(12020, "__item blood cubic zirconia", url, ChecklistSubentryMake(title, "", description), priority));
}
