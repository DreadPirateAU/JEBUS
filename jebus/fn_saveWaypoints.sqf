//Save waypoint data
// [<unitGroup>] call jebus_fnc_saveWaypoints

params [
	"_unitGroup"
];

private ["_waypointList"];

_waypointList = [];

if (count (waypoints _unitGroup) > 1) then {
	for "_waypointIndex" from 1 to (count (waypoints _unitGroup) - 1) do {
		_currentWaypoint = [];

		_currentWaypoint pushBack waypointPosition [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointBehaviour [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointCombatMode [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointCompletionRadius [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointFormation [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointScript [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointSpeed [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointStatements [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointTimeout [_unitGroup, _waypointIndex];
		_currentWaypoint pushBack waypointType [_unitGroup, _waypointIndex];

		_waypointList set [_waypointIndex, _currentWaypoint];
	};
};

_waypointList;
