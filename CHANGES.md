#Release 6.1.4 (in development)
* Migrated to Ace libraries

#Release 6.1.3, Sun, 15 Mar 2015
* Added checking that rule target is a player, not a pet or something
* Fixed typo in help for `buff` rule
* Added optional `min_damage` argument for `damagetaken` rule, 0 by default

#Release 6.1.2, Sat, 14 Mar 2015
* Fixed bug with announcement channel selecting, thanks to @SimplEMeaT 

#Release 6.1.1, Sun, 08 Mar 2015
* Help is now being printed line by line
* Added `protect` command with `buff` and `cast` options. Protects from taking damage penalties
* Announce is now properly using say/raid channels by default depending on your raid status
* Implemented `autologging` command
* Implemented `status` command
* Implemented EP and GP support. Also, negative values may be specified
* Implemented `interrupt` event
* Implemented `dispel` event
* Syntax change: `on event` changed to `for event`