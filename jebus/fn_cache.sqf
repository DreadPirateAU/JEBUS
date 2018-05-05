// Caches a Jebus group if no players are within a certain radius
// [<group>, <radius>, <debug>] spawn jebus_fnc_cache;
params [
	"_group"
	,"_radius"
	,"_debug"
];

if (_debug) then { systemChat "Jebus Cache is active"; };

_group setVariable ["IsCached", false];

while {{alive _x} count (units _group) > 0} do {

	sleep 5;

	if ([getPos (leader _group), _radius] call jebus_fnc_playerInRadius) then {
		if (_group getVariable "IsCached") then {
			if (_debug) then { systemChat "Jebus Cache. Uncaching group."; };
			
			{
				(vehicle _x) hideObjectGlobal false;
				_x enableSimulationGlobal true;
			} forEach units _group;
			
			_group setVariable ["IsCached", false];
		};
	} else {
		if (!(_group getVariable "IsCached")) then {
			if (_debug) then { systemChat "Jebus Cache. Caching group."; };
			
			{
				(vehicle _x) hideObjectGlobal true;
				_x enableSimulationGlobal false;
			} forEach units _group;
			
			_group setVariable ["IsCached", true];
		};
	};
};
