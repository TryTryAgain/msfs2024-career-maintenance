# Changelog

### v1.3.5 - 2025-02-17 - Cruise Control

#### Added

- BETA: Ability to bulk toggle Crew On/Off for a company's fleet (or range within)
  - See [the GitHub issue for more info](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/1)
  - Initial support for English (en-US), German (de-DE), French (fr-FR), and Norwegian (nb-NO)
- Added/split `navDelay` default 150ms (considerably increases speed on large fleets)
- Also added a `crewDelay` default sleep of 500ms

#### Changed

- More defaults (many times faster overall)
  - `cycleDelay` 800ms -> 1000ms
  - removed unnecessary tooltips and sleeps

### v1.2.3 - 2025-02-14 - Time

#### Added

- Added timer, total/elapsed time in HH:MM:SS printed in the final `MsgBox` dialog.

#### Changed

- `keyDelay` 200ms -> 300ms ... as I noticed a few getting missed when operating on large fleets.

### v1.1.2 - 2025-02-13 - Whoops

#### Fixed
- Fixed `if` statements, multiline needed to be wrapped in `{}`. Otherwise it was running the second extendedMaintenance check even if extendedMaintenance was not equal to true.

### v1.1.1 - 2025-02-13 - Stuff

#### Added
- Added `^c::ExitApp ; Press "Ctrl+C" at any time to exit the script` (sometimes you may need to press `CTRL+C` multiple times...)
- Added "Out of order" maintenance handling.
- Added/split `maintenanceDelay` out from `keyDelay` so `keyDelay` can be faster and maintenance tasks don't get messed up or missed.
- Added new `startFrom` and `endAt` options to allow for more selection flexibility and range options when choosing which planes to perform maintenance on in a fleet.
- Groundwork for deep/extended maintenance inspection.

#### Changed
- Sped it up (defaults changed)
  - `keyDelay` 750ms -> 200ms
  - `cycleDelay` 1100ms -> 900ms
  - You can now skip the general "Update check up" using `"-updateCheckUp", "false"`

#### Fixed
- Fixed an edge case "Buy aircraft" bug (when operating on a company with only one plane). See [https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/2#issuecomment-2652612863](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/2#issuecomment-2652612863)
- It now handles "Out of order" red maintenance tasks now in addition to the regular orange "To maintain" and "Warn".
- It now handles interstitial insurance claims when repairs have insurance refunds.

### v1.0.1 - 2025-02-10 - Learning

#### Fixed
- Initial fix for [BUG - Occasionally it incorrectly selects "Buy aircraft" instead of the first aircraft in the fleet](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/2)

### v1.0 - 2025-02-09 - Initial Release!
