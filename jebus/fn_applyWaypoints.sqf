//Save waypoint data
// [<unitGroup>] call jebus_fnc_saveWaypoints

params [
	"_newGroup"
	,"_waypointList"
	,"_debug"
];

if (!(_waypointList isEqualTo [])) then {
	if (_debug) then {systemChat "Applying waypoints."};
	for "_waypointIndex" from 1 to (count (_waypointList) - 1) do {
		_currentWaypoint = _waypointList select _waypointIndex;

		_newWaypoint = _newGroup addWaypoint [(_currentWaypoint select 0), _waypointIndex];

		_newWaypoint setwaypointBehaviour (_currentWaypoint select 1);
		_newWaypoint setwaypointCombatMode (_currentWaypoint select 2);
		_newWaypoint setwaypointCompletionRadius (_currentWaypoint select 3);
		_newWaypoint setwaypointFormation (_currentWaypoint select 4);
		_newWaypoint setwaypointScript (_currentWaypoint select 5);
		_newWaypoint setwaypointSpeed (_currentWaypoint select 6);
		_newWaypoint setwaypointStatements (_currentWaypoint select 7);
		_newWaypoint setwaypointTimeout (_currentWaypoint select 8);
		_newWaypoint setwaypointType (_currentWaypoint select 9);
	};
};