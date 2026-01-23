
RegisterResourceGenerationFunction("IOTMMayamCalendarGenerateResource");
void IOTMMayamCalendarGenerateResource(ChecklistEntry [int] resource_entries)
{
	if ($item[Mayam Calendar].available_amount() == 0) return;

	// Parse used symbols - property is just a flat comma-separated list of all symbols used
	// We need to map each symbol to its ring and track usage by ring
	string used_symbols_raw = get_property("_mayamSymbolsUsed");
	boolean [string] used_outer;
	boolean [string] used_second;
	boolean [string] used_third;
	boolean [string] used_inner;

	// Define which symbols belong to which rings
	boolean [string] outer_ring_symbols;
	outer_ring_symbols["yam1"] = true;
	outer_ring_symbols["sword"] = true;
	outer_ring_symbols["vessel"] = true;
	outer_ring_symbols["fur"] = true;
	outer_ring_symbols["chair"] = true;
	outer_ring_symbols["eye"] = true;

	boolean [string] second_ring_symbols;
	second_ring_symbols["yam2"] = true;
	second_ring_symbols["lightning"] = true;
	second_ring_symbols["bottle"] = true;
	second_ring_symbols["wood"] = true;
	second_ring_symbols["meat"] = true;

	boolean [string] third_ring_symbols;
	third_ring_symbols["yam3"] = true;
	third_ring_symbols["eyepatch"] = true;
	third_ring_symbols["cheese"] = true;
	third_ring_symbols["wall"] = true;

	boolean [string] inner_ring_symbols;
	inner_ring_symbols["yam4"] = true;
	inner_ring_symbols["clock"] = true;
	inner_ring_symbols["explosion"] = true;

	int uses_made = 0;
	if (used_symbols_raw != "")
	{
		string [int] symbols_list = used_symbols_raw.split_string(",");
		uses_made = symbols_list.count() / 4;

		// Parse each symbol and assign to the correct ring
		foreach key in symbols_list
		{
			string symbol = symbols_list[key];

			if (outer_ring_symbols contains symbol)
			{
				if (symbol == "yam1") symbol = "yam";
				used_outer[symbol] = true;
			}
			else if (second_ring_symbols contains symbol)
			{
				if (symbol == "yam2") symbol = "yam";
				used_second[symbol] = true;
			}
			else if (third_ring_symbols contains symbol)
			{
				if (symbol == "yam3") symbol = "yam";
				used_third[symbol] = true;
			}
			else if (inner_ring_symbols contains symbol)
			{
				if (symbol == "yam4") symbol = "yam";
				used_inner[symbol] = true;
			}
		}
	}

	// Calculate uses remaining (max 3 since inner ring has only 3 symbols)
	int uses_remaining = 3 - uses_made;
	if (uses_remaining <= 0) return;

	string [int] description;

	// Define individual symbol benefits for tooltips
	string [string] outer_benefits;
	outer_benefits["yam"] = "yam (item)";
	outer_benefits["sword"] = "+mus (10x level, max 150)";
	outer_benefits["vessel"] = "Vessel of Magic (100 turns) + 1000 MP";
	outer_benefits["fur"] = "100 fam XP";
	outer_benefits["chair"] = "5 free rests";
	outer_benefits["eye"] = "Big Eyes (100 turns)";

	string [string] second_benefits;
	second_benefits["yam"] = "yam (item)";
	second_benefits["lightning"] = "+myst (10x level, max 150)";
	second_benefits["bottle"] = "Bottled Fortitude (100 turns) + 1000 HP";
	second_benefits["wood"] = "2 lumber + 2 fasteners";
	second_benefits["meat"] = "+meat (100x level, max 1500)";

	string [string] third_benefits;
	third_benefits["yam"] = "yam (item)";
	third_benefits["eyepatch"] = "+mox (10x level, max 150)";
	third_benefits["cheese"] = "goat cheese (item)";
	third_benefits["wall"] = "Walled In (100 turns)";

	string [string] inner_benefits;
	inner_benefits["yam"] = "yam (item)";
	inner_benefits["clock"] = "+5 adventures";
	inner_benefits["explosion"] = "+5 PvP fights";

	// Define all special combinations (Outer, Second, Third, Inner -> Result)
	string [int][5] combinations;
	int combo_count = 0;

	// Items from combinations
	combinations[combo_count][0] = "eye"; combinations[combo_count][1] = "yam"; combinations[combo_count][2] = "eyepatch"; combinations[combo_count][3] = "yam"; combinations[combo_count][4] = "Mayam spinach"; combo_count++;
	combinations[combo_count][0] = "yam"; combinations[combo_count][1] = "meat"; combinations[combo_count][2] = "cheese"; combinations[combo_count][3] = "yam"; combinations[combo_count][4] = "yam and swiss"; combo_count++;
	combinations[combo_count][0] = "sword"; combinations[combo_count][1] = "yam"; combinations[combo_count][2] = "eyepatch"; combinations[combo_count][3] = "explosion"; combinations[combo_count][4] = "yam cannon"; combo_count++;
	combinations[combo_count][0] = "fur"; combinations[combo_count][1] = "lightning"; combinations[combo_count][2] = "eyepatch"; combinations[combo_count][3] = "yam"; combinations[combo_count][4] = "tiny yam cannon"; combo_count++;
	combinations[combo_count][0] = "yam"; combinations[combo_count][1] = "lightning"; combinations[combo_count][2] = "yam"; combinations[combo_count][3] = "clock"; combinations[combo_count][4] = "yam battery"; combo_count++;
	combinations[combo_count][0] = "vessel"; combinations[combo_count][1] = "yam"; combinations[combo_count][2] = "cheese"; combinations[combo_count][3] = "explosion"; combinations[combo_count][4] = "stuffed yam stinkbomb"; combo_count++;
	combinations[combo_count][0] = "fur"; combinations[combo_count][1] = "yam"; combinations[combo_count][2] = "wall"; combinations[combo_count][3] = "yam"; combinations[combo_count][4] = "furry yam buckler"; combo_count++;
	combinations[combo_count][0] = "yam"; combinations[combo_count][1] = "yam"; combinations[combo_count][2] = "yam"; combinations[combo_count][3] = "explosion"; combinations[combo_count][4] = "thanksgiving bomb"; combo_count++;
	combinations[combo_count][0] = "yam"; combinations[combo_count][1] = "meat"; combinations[combo_count][2] = "eyepatch"; combinations[combo_count][3] = "yam"; combinations[combo_count][4] = "yamtility belt"; combo_count++;

	// Effects from combinations
	combinations[combo_count][0] = "chair"; combinations[combo_count][1] = "yam"; combinations[combo_count][2] = "yam"; combinations[combo_count][3] = "clock"; combinations[combo_count][4] = "Caught Yam-Handed (30 turns)"; combo_count++;
	combinations[combo_count][0] = "yam"; combinations[combo_count][1] = "yam"; combinations[combo_count][2] = "cheese"; combinations[combo_count][3] = "clock"; combinations[combo_count][4] = "Memories of Cheesier Age (30 turns)"; combo_count++;

	// Filter available combinations
	string [int][int] available_table;
	available_table.listAppend(listMake(HTMLGenerateSpanOfClass("Outer", "r_bold"), HTMLGenerateSpanOfClass("Second", "r_bold"), HTMLGenerateSpanOfClass("Third", "r_bold"), HTMLGenerateSpanOfClass("Inner", "r_bold"), HTMLGenerateSpanOfClass("Result", "r_bold")));

	foreach idx in combinations
	{
		string outer = combinations[idx][0];
		string second = combinations[idx][1];
		string third = combinations[idx][2];
		string inner = combinations[idx][3];
		string result = combinations[idx][4];

		// Check if all symbols are available in their respective rings
		if (used_outer contains outer) continue;
		if (used_second contains second) continue;
		if (used_third contains third) continue;
		if (used_inner contains inner) continue;

		// Create tooltips for each symbol
		string outer_display = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(outer_benefits[outer], "r_tooltip_inner_class") + outer.capitaliseFirstLetter(), "r_tooltip_outer_class");
		string second_display = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(second_benefits[second], "r_tooltip_inner_class") + second.capitaliseFirstLetter(), "r_tooltip_outer_class");
		string third_display = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(third_benefits[third], "r_tooltip_inner_class") + third.capitaliseFirstLetter(), "r_tooltip_outer_class");
		string inner_display = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(inner_benefits[inner], "r_tooltip_inner_class") + inner.capitaliseFirstLetter(), "r_tooltip_outer_class");

		available_table.listAppend(listMake(outer_display, second_display, third_display, inner_display, result));
	}

	if (available_table.count() > 1)
	{
		description.listAppend("Available combinations:|*" + HTMLGenerateSimpleTableLines(available_table));
	}
	else
	{
		description.listAppend("No special combinations available with remaining symbols.");
	}

	string title = pluralise(uses_remaining, "use", "uses") + " remaining";
	resource_entries.listAppend(ChecklistEntryMake(11572, "__item mayam calendar", "inv_use.php?pwd=" + my_hash() + "&whichitem=11572", ChecklistSubentryMake(title, "", description), 0));
}
