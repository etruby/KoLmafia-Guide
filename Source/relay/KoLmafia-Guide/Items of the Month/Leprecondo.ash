
// Leprecondo (March 2025 IOTM)
// A tiny condo for your Leprechaun familiar with configurable furniture in 4 rooms
// Leprechaun cycles through 6 needs every 5 turns: booze, food, entertainment, exercise, mental stimulation, sleep
// When a need is active and you have matching furniture, you get bonuses after combat

// Furniture IDs and their properties
// Format: furniture_id -> [name, need1, need2 (or ""), benefit description]
string [int][int] __leprecondo_furniture_data;

void initLeprecondoFurnitureData()
{
	if (__leprecondo_furniture_data.count() > 0) return;

	// Data from KoLmafia's LeprecondoManager.java - furniture IDs 1-27
	// Format: [name, need1, need2, benefit description]
	// Needs: "mental stimulation", "exercise", "dumb entertainment", "food", "booze", "sleep"

	__leprecondo_furniture_data[1] = listMake("buckets of concrete", "exercise", "", "+1 mus stats, +20% mus");
	__leprecondo_furniture_data[2] = listMake("thrift store oil painting", "mental stimulation", "", "+1 myst stats, +20% myst");
	__leprecondo_furniture_data[3] = listMake("boxes of old comic books", "dumb entertainment", "", "+1 mox stats, +20% mox");
	__leprecondo_furniture_data[4] = listMake("second-hand hot plate", "food", "", "random decent food");
	__leprecondo_furniture_data[5] = listMake("beer cooler", "booze", "", "crappy/decent beer");
	__leprecondo_furniture_data[6] = listMake("free mattress", "sleep", "", "+25% init");
	__leprecondo_furniture_data[7] = listMake("gigantic chess set", "exercise", "mental stimulation", "+20 mus, +50% HP / +1 myst stats, +20% myst");
	__leprecondo_furniture_data[8] = listMake("UltraDance karaoke machine", "dumb entertainment", "exercise", "+5 fam weight, +5 fam XP / +15% item");
	__leprecondo_furniture_data[9] = listMake("cupcake treadmill", "exercise", "food", "+5 fam weight, +5 fam XP / cupcake");
	__leprecondo_furniture_data[10] = listMake("beer pong table", "booze", "exercise", "beer / table tennis ball (delevel)");
	__leprecondo_furniture_data[11] = listMake("padded weight bench", "exercise", "sleep", "+1 mus stats, +20% mus / -5% combat");
	__leprecondo_furniture_data[12] = listMake("internet-connected laptop", "dumb entertainment", "mental stimulation", "+1 mox stats, +20% mox / crafting plans");
	__leprecondo_furniture_data[13] = listMake("sous vide laboratory", "food", "mental stimulation", "random good food / +30% meat");
	__leprecondo_furniture_data[14] = listMake("programmable blender", "mental stimulation", "booze", "+30% meat / size-3 booze");
	__leprecondo_furniture_data[15] = listMake("sensory deprivation tank", "mental stimulation", "sleep", "+20 myst, +50% MP / +50% init, MP regen");
	__leprecondo_furniture_data[16] = listMake("fruit-smashing robot", "dumb entertainment", "food", "+20 mox, 10 DR / 2 random fruits");
	__leprecondo_furniture_data[17] = listMake("ManCave sports bar set", "dumb entertainment", "booze", "bar dart (+200% booze) / schnapps");
	__leprecondo_furniture_data[18] = listMake("couch and flatscreen", "dumb entertainment", "sleep", "+5 fam weight, +5 fam XP / +25% init");
	__leprecondo_furniture_data[19] = listMake("kegerator", "food", "booze", "leftovers / Leprechaun Stout");
	__leprecondo_furniture_data[20] = listMake("fine upholstered dining set", "food", "sleep", "good food (size 3-4) / +5-10 MP/HP regen");
	__leprecondo_furniture_data[21] = listMake("whiskeybed", "booze", "sleep", "whiskey / +50% init, +2 hot res");
	__leprecondo_furniture_data[22] = listMake("high-end home workout system", "exercise", "", "pre-workout powder (banish, 3 spleen)");
	__leprecondo_furniture_data[23] = listMake("complete classics library", "mental stimulation", "", "antidepressant (+10% combat, +50% damage, 3 spleen)");
	__leprecondo_furniture_data[24] = listMake("ultimate retro game console", "dumb entertainment", "", "phosphor traces (copy, 3 spleen)");
	__leprecondo_furniture_data[25] = listMake("Omnipot", "food", "", "random awesome food (size 1-2)");
	__leprecondo_furniture_data[26] = listMake("fully-stocked wet bar", "booze", "", "random awesome booze (size 1-2)");
	__leprecondo_furniture_data[27] = listMake("four-poster bed", "sleep", "", "+100% init, +10% all stats (20 turns)");
}

string getLeprecondoFurnitureName(int furniture_id)
{
	initLeprecondoFurnitureData();
	if (!(__leprecondo_furniture_data contains furniture_id)) return "Unknown";
	return __leprecondo_furniture_data[furniture_id][0];
}

string getLeprecondoFurnitureNeeds(int furniture_id)
{
	initLeprecondoFurnitureData();
	if (!(__leprecondo_furniture_data contains furniture_id)) return "";
	string need1 = __leprecondo_furniture_data[furniture_id][1];
	string need2 = __leprecondo_furniture_data[furniture_id][2];
	if (need2 == "") return need1;
	return need1 + "/" + need2;
}

string getNeedEmoji(string need)
{
	if (need == "booze") return "🍻";
	if (need == "food") return "🍏";
	if (need == "dumb entertainment" || need == "entertainment") return "📺";
	if (need == "exercise") return "💪";
	if (need == "mental stimulation" || need == "mental") return "🧠";
	if (need == "sleep") return "🌙";
	return "";
}

boolean leprecondoIsAvailable()
{
	// Check if player has the Leprecondo
	if (!$item[Leprecondo].is_unrestricted()) return false;
	// Check if they've discovered any furniture (indicates they have it)
	string discovered = get_property("leprecondoDiscovered");
	string installed = get_property("leprecondoInstalled");
	// If they have the item or have used it
	if ($item[assemble-it-yourself Leprecondo].available_amount() > 0) return true;
	if ($item[Leprecondo].available_amount() > 0) return true;
	if (discovered != "" || installed != "0,0,0,0") return true;
	return get_property_boolean("hasLeprecondo");
}

RegisterResourceGenerationFunction("IOTMLeprecondoGenerateResource");
void IOTMLeprecondoGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!leprecondoIsAvailable()) return;

	initLeprecondoFurnitureData();

	string [int] description;
	string url = "inv_use.php?whichitem=11861&pwd=" + my_hash();

	// Get current state
	string current_need = get_property("leprecondoCurrentNeed");
	int last_need_change = get_property_int("leprecondoLastNeedChange");
	string need_order = get_property("leprecondoNeedOrder");
	string installed_raw = get_property("leprecondoInstalled");
	int rearrangements_used = get_property_int("_leprecondoRearrangements");
	int furniture_dropped_today = get_property_int("_leprecondoFurniture");

	// Parse installed furniture
	int [int] installed_furniture;
	if (installed_raw != "" && installed_raw != "0,0,0,0")
	{
		string [int] parts = installed_raw.split_string(",");
		foreach i in parts
		{
			installed_furniture[i] = parts[i].to_int();
		}
	}

	// Calculate turns until next need change (needs last 5 turns each)
	int turns_since_change = my_turncount() - last_need_change;
	int turns_until_next = 5 - (turns_since_change % 5);
	if (turns_until_next == 5 && turns_since_change > 0) turns_until_next = 0;

	// Show current need status
	if (current_need != "")
	{
		string need_display = getNeedEmoji(current_need) + " " + current_need.to_upper_case();
		if (turns_until_next > 0)
			description.listAppend("Current need: " + need_display + " (" + pluralise(turns_until_next, "turn", "turns") + " remaining)");
		else
			description.listAppend("Current need: " + need_display + " (changing soon)");
	}

	// Show installed furniture and what benefits are active
	boolean has_furniture = false;
	string [int] active_benefits;
	string [int] furniture_list;

	string [int] room_names = listMake("Top Left", "Top Right", "Bottom Left", "Bottom Right");
	foreach i, furniture_id in installed_furniture
	{
		if (furniture_id > 0)
		{
			has_furniture = true;
			string name = getLeprecondoFurnitureName(furniture_id);
			string needs = getLeprecondoFurnitureNeeds(furniture_id);
			furniture_list.listAppend(room_names[i] + ": " + name + " (" + needs + ")");
		}
	}

	if (furniture_list.count() > 0)
	{
		description.listAppend("Installed:|*" + furniture_list.listJoinComponents("|*"));
	}

	// Show rearrangements remaining
	int rearrangements_remaining = 3 - rearrangements_used;
	if (rearrangements_remaining > 0)
	{
		description.listAppend(pluralise(rearrangements_remaining, "rearrangement", "rearrangements") + " remaining today.");
	}

	// Highlight key resources/combos
	string [int] key_resources;

	// Check for copies (phosphor traces from ultimate retro game console - id 24)
	// Check for banishes (pre-workout powder from high-end home workout system - id 22)
	// Check for crafting (crafting plans from internet-connected laptop - id 12)
	// Check for fam XP (karaoke=8, treadmill=9, couch=18)
	boolean has_copies = false;
	boolean has_banishes = false;
	boolean has_crafting = false;
	boolean has_fam_xp = false;

	foreach i, furniture_id in installed_furniture
	{
		if (furniture_id == 24) has_copies = true;
		if (furniture_id == 22) has_banishes = true;
		if (furniture_id == 12) has_crafting = true;
		if (furniture_id == 8 || furniture_id == 9 || furniture_id == 18) has_fam_xp = true;
	}

	if (has_copies)
		key_resources.listAppend("📺 Copies (phosphor traces) available when dumb entertainment need triggers");
	if (has_banishes)
		key_resources.listAppend("💪 Banishes (pre-workout powder) available when exercise need triggers");
	if (has_crafting)
		key_resources.listAppend("🧠 Free crafting available when mental stimulation need triggers");
	if (has_fam_xp)
		key_resources.listAppend("+5 fam weight/XP buff available");

	if (key_resources.count() > 0)
	{
		description.listAppend("Key resources:|*" + key_resources.listJoinComponents("|*"));
	}

	// Show recommendations if no furniture installed
	if (!has_furniture && __misc_state["in run"])
	{
		description.listAppend("Recommended combos for speedruns:");
		description.listAppend("*Copies+Buffs: Ultimate retro game console + Cupcake treadmill");
		description.listAppend("*Banishes+Crafting: High-end workout system + Internet-connected laptop");
		description.listAppend("*Max familiar XP: UltraDance karaoke + Cupcake treadmill + Couch and flatscreen");
	}

	// Show need order if known (helps planning)
	if (need_order != "")
	{
		string [int] needs_list = need_order.split_string(",");
		string [int] needs_display;
		foreach i in needs_list
		{
			string n = needs_list[i];
			needs_display.listAppend(getNeedEmoji(n) + n);
		}
		description.listAppend("Need order: " + needs_display.listJoinComponents(" → "));
	}

	string title;
	if (current_need != "")
		title = "Leprecondo: " + getNeedEmoji(current_need) + " " + current_need;
	else
		title = "Leprecondo";

	// Item ID for Leprecondo is 11861 (from wiki)
	resource_entries.listAppend(ChecklistEntryMake(11861, "__item Leprecondo", url, ChecklistSubentryMake(title, "", description), 8));
}

// Task generation for suggesting furniture setup
RegisterTaskGenerationFunction("IOTMLeprecondoGenerateTasks");
void IOTMLeprecondoGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!leprecondoIsAvailable()) return;
	if (!__misc_state["in run"]) return;

	string installed_raw = get_property("leprecondoInstalled");
	int rearrangements_used = get_property_int("_leprecondoRearrangements");

	// If no furniture installed at all, suggest setting it up
	if (installed_raw == "" || installed_raw == "0,0,0,0")
	{
		string [int] description;
		description.listAppend("Configure your Leprecondo furniture for the run.");
		description.listAppend("Popular setups include:");
		description.listAppend("*Copies/Banishes: retro console + workout system");
		description.listAppend("*Familiar XP: karaoke + treadmill + couch");
		description.listAppend("*Crafting: internet-connected laptop");

		optional_task_entries.listAppend(ChecklistEntryMake(11861, "__item Leprecondo", "inv_use.php?whichitem=11861&pwd" + my_hash(), ChecklistSubentryMake("Set up Leprecondo furniture", "", description), 8));
	}
}
