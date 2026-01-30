# IOTM Implementation Plan

## Strategy
- Implement IOTMs **one at a time**, starting from most recent
- Test each implementation before moving to the next
- Focus on Standard-legal items first (2024-2026)

## User's Collection
- **Has**: All IOTMs from 2015 onward (with some gaps pre-2015)
- **Has**: Items of the Year from 2018 onward
- **Priority**: Standard-legal items (current year + previous 2 years)

## Current Year: 2026
- Standard includes: 2024, 2025, 2026

---

## Implementation Queue

### January 2026
✅ **seal-clubbing club loot box** - ALREADY IMPLEMENTED

### 2025 (Working backward from December)
1. ✅ **stocking full of bones** (December 2025) - IMPLEMENTED
2. ✅ **shrunken head in a duffel bag** (November 2025) - IMPLEMENTED
3. ✅ **lab-grown blood cubic zirconia** (October 2025) - IMPLEMENTED
4. ✅ **packaged Monodent of the Sea** (September 2025) - IMPLEMENTED
5. ✅ **Möbius ring box** (August 2025) - IMPLEMENTED
6. ❌ **yeti in a travel cooler** (July 2025)
7. ❌ **packaged prismatic beret** (June 2025)
8. ❌ **Unpeeled Peridot of Peril** (May 2025)
9. ✅ **Packaged April Shower Thoughts Calendar** (April 2025) - IMPLEMENTED
10. ✅ **assemble-it-yourself Leprecondo** (March 2025) - IMPLEMENTED
11. ❌ **new-in-box toy Cupid bow** (February 2025)
12. ✅ **McHugeLarge deluxe ski set** (January 2025) - IMPLEMENTED

### 2024 (Working backward from December)
1. ✅ **Sealed TakerSpace letter of Marque** (December 2024) - IMPLEMENTED
2. ❌ **peace turkey outline** (November 2024)
3. ✅ **boxed bat wings** (October 2024) - IMPLEMENTED
4. ❌ **boxed SeptEmber Censer** (September 2024)
5. ❌ **untorn tearaway pants package** (August 2024)
6. ❌ **packaged Roman Candelabra** (July 2024)
7. ❌ **mini kiwi egg** (June 2024)
8. ✅ **boxed Mayam Calendar** (May 2024) - IMPLEMENTED
9. ❌ **boxed Apriling band helmet** (April 2024)
10. ❌ **packaged Everfull Dart Holster** (March 2024)
11. ❌ **in-the-box spring shoes** (February 2024)
12. ❌ **baby chest mimic** (January 2024)

---

## Items of the Year (owned from 2018+)

### Need to implement:
- ✅ **The Eternity Codpiece** (2026) - IMPLEMENTED
- ❌ **server room key** (2025) - from CyberRealm keycode
- ❌ **Black and White Apron Meal Kit** (2024)
- ❌ **Hobo in Sheep's Clothing** (2023)
- ❌ **cursed magnifying glass** (2022)
- ❌ **fresh coat of paint** (2021)
- ❌ **Retrospecs** (2020)
- ❌ **Elf Operative** (2019)
- ❌ **Garbage Fire** (2018)

---

## Next Steps

1. **Choose first IOTM to implement** from 2025 or 2024
2. **Research the IOTM's mechanics** (wiki, mafia source code, etc.)
3. **Design implementation**:
   - What advice/reminders should Guide show?
   - When should it show them? (daily reset, usage tracking, etc.)
   - What state needs to be tracked?
4. **Create the .ash file** in `Items of the Month/`
5. **Add import** to `Items of the Month import.ash`
6. **Test** with the compiled version
7. **Move to next IOTM**

---

## Notes

- User preferences file saved in `.reference/sample_prefs.txt`
- Many prefs are prefixed with `_` for daily-reset tracking (e.g., `_aprilBandInstruments`)
- Non-prefixed prefs persist across days/ascensions
- Use KoLmafia's `get_property()` and `set_property()` functions to track state
