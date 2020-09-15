Jebus - Just Editor Based Unit Spawning
Version: 1.453
Release Date: 2020/9/15
Author: DreadPirate

Short Description:
This script takes editor-based groups and respawns them when the group is eliminated

Description:
This script takes editor-based groups and respawns them when the group is eliminated
The group's waypoints are saved
The group's loadouts are saved
Multiple respawn positions are available
Spawning can be synchronized with a trigger to create groups when needed
The number of respawns can be set, or it can respawn infinitely
The respawn delay can be a fixed number or a range
A pause radius is available so groups don't spawn on top of other units
An exit trigger can be used to exit the script early
Integrated GAIA support
https://forums.bistudio.com/topic/172933-mission-template-stand-alone-gaia-make-missions-fast-by-using-mcc-gaia-engine/
A custom init string can be used to run your favourite patrol script, attack script, gear script, etc.
Units are added to Zeus automatically
Use it for ambient combat, waves of attackers, random patrols or whatever else you think of.....

Installation / Usage:
1. Copy the jebus folder into your mission folder
2. Copy description.ext into your mission folder (or merge description.ext with yours)
3. Place a group in the editor 
4. Call the script in the initialization box of the leader or group (examples given below)
5. Option: Synchronize a trigger with the group leader. The group will not spawn until the trigger is activated

Installing to a sub-folder
1. Copy the jebus folder into your mission sub-folder (eg scripts)
2. Copy description.ext into your mission folder (or merge description.ext with yours)
3. Edit description.ext to point to sub-folder (eg #include "scripts\jebus\cfgFunctions.hpp")
4. Proceed as normal

Parameters:
this				= Leader of a group
"LIVES="			= Number of times group should respawn
				  Integer or array [minLives, maxLives]. Default is infinite lives
"DELAY="			= Delay in seconds before respawning
				  Number or array [minTime, maxTime]
				  Default is 30 seconds
"CACHE="			= Group will cache until players are within "CACHE=" metres
				  Default is no caching
"REDUCE="			= Group will cache until players are within "REDUCE=" metres
				  Default is no reducing
"START="			= Initial spawning delay. Use if you spawn multiple groups by one trigger to avoid spawn
				  lag. Default is 0.
"GAIA_MOVE="			= Group added to GAIA with "MOVE" parameter
"GAIA_NOFOLLOW="		= Group added to GAIA with "NOFOLLOW" parameter
"GAIA_FORTIFY="			= Group added to GAIA with "FORTIFY" parameter
"FLYING"			= Air vehicles will spawn already flying
"RESPAWNMARKERS="		= Array of alternate respawn positions
"PAUSE="			= Radius in which enemies will pause the spawner. Default is 0.
"EXIT="				= Name of exit trigger
				  Group will not respawn again once trigger is activated
"INIT="				= Init string to run upon spawning
				  (Use "_proxyThis" where you would usually use "this" in a script or function call)
				  Default is empty string.
"RECRUIT="			= Units in group can be recruited by players
"DEBUG"				= Will provide debugging information

Examples:

0 = [this] spawn jebus_fnc_main;
Respawns group with default parameters. Uses editor waypoints.

0 = [this, "LIVES=", [4,8]] spawn jebus_fnc_main;
Respawns group 4 - 8 times. Uses editor waypoints.

0 = [this, "DELAY=", [30,60]] spawn jebus_fnc_main;
Respawns group after 30 - 60 seconds delay. Uses editor waypoints.

0 = [this, "CACHE=", 500, "GAIA_NOFOLLOW=", "3"] spawn jebus_fnc_main;
Group uncaches when players are within 500m of spawn position. Assigns group to GAIA zone 3.

0 = [this, "PAUSE=", 100, "INIT=", "[_proxyThis, 'agia'] execVM 'UPS.sqf'"] spawn jebus_fnc_main;
Group initializes Kronzky's UPS script to patrol a marker named 'agia'.
Respawning will pause if enemies are within 100m of spawn position.

0 = [this, "GAIA_MOVE=", "9", "RESPAWNMARKERS=", ["m1", "m2"]]spawn jebus_fnc_main;
Group will respawn randomly at its editor position or "m1" or "m2". Assigned to GAIA zone 9.

0 = [this, "GAIA_NOFOLLOW=", "10", "EXIT=", myExitTrigger] spawn jebus_fnc_main;
Group will respawn until myExitTrigger is activated.

Changelog:
v1.0 (2014/10/28) 	- First release
v1.1 (2014/11/9) 	- Added support for Motorized, Mechanized & Armored groups
					- Added trigger activated spawning
v1.2 (2015/2/21)	- Added debugging information
					- Added variable respawn delay
					- Improved readability of installation and code
					- Various tweaks
v1.3 (2015/3/17)	- ArmA 2 first release
					- Made parameters more user friendly
					- Added variable number of respawns
					- Added simple patrol script
					- Added simple attack script
					- Added pilot kill script
v1.31 (2015/3/30)	- Added reset when no enemies are within certain radius
					- Added Arma 2 demo mission
v1.32 (2015/5/8)	- Switched to using nearEntities instead of nearestObjects
					- Changed activation and reset to detect players
v1.33 (2016/3/27)	- Eden update
					- Changed activation and reset to a caching system
					- Simplified calling attack and patrol scripts
					- Now handles units in vehicle cargo correctly
					- Air vehicles can be spawned on ground or flying
					- Diver and boat support
					- Integrated GAIA support
					- Added group clean up
					- Discontinued ArmA 2 support
v1.34 (2016/4/3)	- Added waypoint support
					- Added variable respawn position support
					- Added exit trigger support
					- Removed simple attack and patrol scripts (use waypoints instead)
v1.35 (2016/4/29)	- Fixed caching with hideObjectGlobal and enableSimulationGlobal
					- Editor loadouts are saved and restored on respawn
v1.36 (2016/10/2)	- Script can be called from GROUP init (Thanks to S.Crowe)
					- Locked status of vehicles saved and restored
					- Cargo of vehicles saved and restored
v1.37 (2017/1/1)	- Moved trigger activation inside main loop (Thanks to pritchardgsd)
					- Switched to using getUnitLoadout over BIS_fnc_saveInventory
					- Switched to using setUnitLoadout over BIS_fnc_loadInventory
					- Fixed planes spawning with "FLYING"
v1.38 (2017/2/26)	- Vehicles will respawn in editor positions
					- "REDUCE=" added. Reduces a group to just the leader until players are within range (infantry only)
v1.39 (2017/3/10)	- Skill levels are saved
					- Various tweaks and fixes
v1.40 (2017/10/2)	- Moved JEBUS into its own folder. Reorganised code.
					- Dynamic Loadout support
					- "START=" added. Initial spawning delay
					- Multi vehicle groups support RESPAWNMARKERS
					- Various tweaks and fixes
v1.41 (2017/12/29)	- Stopped units moving to default spawn position when using RESPAWNMARKERS
v1.42 (2018/5/6)	- The behemeth update
					- Backpacks in vehicle cargo saved
					- Vehicle fuel and hitpoints saved
					- Vehicle skin, camonets, slat armour, etc. saved
					- Group synchronizations are saved
v1.43 (2018/7/1)	- Variable names are saved for all group members and vehicles
					- Various tweaks and fixes
v1.431 (2018/7/6)	- Fixed a bug with trigger activation
v1.432 (2019/6/1)	- Variable names are now *actually* saved for all group members and vehicles
					- Pause radius default is now 0
v1.433 (2019/12/29)	- Vehicles spawn 2m off ground (Global Mobilization fix)
					- Various tweaks and fixes
v1.45 (2020/4/17)	- Major code rewrite
					- Changed the Global Mobilization fix to use config entries
					- Added a recruit function
v1.451 (2020/8/13)	- Fixed crew member roles not being assigned correctly
v1.452 (2020/8/19) 	- Fixed empty groups not being deleted
					- Changed how units are added to Zeus
					- Support for static weapons
v1.453 (2020/9/15) 	- Fixed drone support
