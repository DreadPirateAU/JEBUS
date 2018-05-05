// Reduces a Jebus group if no players are within a certain radius
// [<group>, <radius>, <debug>] spawn jebus_fnc_reduce

params [
	"_group"
	,"_radius"
	,"_debug"
];

if (_debug) then { systemChat "Jebus Reduce is active"; };

_group setVariable ["IsReduced", false];

while {{alive _x} count (units _group) > 0} do {

	sleep 5;
	
	_reduceableUnits = units _group - crew (vehicle (leader _group));

	//We need to make sure the leader is active
	(leader _group) hideObjectGlobal false;
	(leader _group) enableSimulationGlobal true;
			
	if ([getPos (leader _group), _radius] call jebus_fnc_playerInRadius) then {
		if (_group getVariable "IsReduced") then {
			if (_debug) then { systemChat "Jebus Reduce. Rebuilding group."; };
							
			{
				(vehicle _x) hideObjectGlobal false;
				_x enableSimulationGlobal true;
				sleep 0.1;
				if ((vehicle _x) isEqualTo _x) then {_x setPos (getPos (leader _group));};
			} forEach _reduceableUnits;
			
			_group setVariable ["IsReduced", false];
		};
	} else {
		if (!(_group getVariable "IsReduced")) then {
			if (_debug) then { systemChat "Jebus Reduce. Reducing group."; };
			
			{
				(vehicle _x) hideObjectGlobal true;
				_x enableSimulationGlobal false;
			} forEach _reduceableUnits;
			
			_group setVariable ["IsReduced", true];
		};
	};
};
