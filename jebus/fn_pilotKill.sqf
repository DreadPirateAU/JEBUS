// Kills the crew of an aircraft when they decide to bail out
// Prevents long respawn waits when aircraft crash far from the battlefield
// [_proxyThis] call jebus_fnc_pilotKill
// Optional second parameter for debugging: [_proxyThis, 'DEBUG'] call jebus_fnc_pilotKill

_aircraft = vehicle (_this select 0);

if ("DEBUG" in _this) then { _debug = true;	};

_crew = crew _aircraft;

if (_debug) then { systemChat "Jebus Pilot Kill is active";	};

waitUntil {!canMove _aircraft};

if (_debug) then { systemChat "Killing crew"; };	

{deleteVehicle _x} foreach _crew;
