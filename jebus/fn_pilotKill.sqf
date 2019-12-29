// Kills the crew of an aircraft when they decide to bail out
// Prevents long respawn waits when aircraft crash far from the battlefield
// [_proxyThis] call jebus_fnc_pilotKill
// Optional second parameter for debugging: [_proxyThis, 'DEBUG'] call jebus_fnc_pilotKill

_aircraft = vehicle (_this select 0);

_debug = false;

if ("DEBUG" in _this) then { _debug = true;	};

_crew = crew _aircraft;

_group = group (_crew select 0);

if (_debug) then { systemChat format["%1 - Jebus Pilot Kill", _group] };

waitUntil {!canMove _aircraft};

if (_debug) then { systemChat format["%1 - Killing crew", _group] };	

{deleteVehicle _x} foreach _crew;
