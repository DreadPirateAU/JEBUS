params [
	"_numCaches"
	,["_debug", false]
];

if (!isServer) exitWith {};

waituntil {!isNil "zonesCreated"};

_cacheTypes = [
	"Box_FIA_Ammo_F"
];

for [{_i = 0},{_i < _numCaches},{_i = _i + 1}] do {
	_zone = selectRandom allZones;
	_buildingPositions = _zone getVariable "BuildingPositions";
	_cachePos = selectRandom _buildingPositions;

	//Remove cache position so units don't spawn there.....
	_buildingPositions = _buildingPositions - _cachePos;
	_zone setVariable ["BuildingPositions", _buildingPositions];

	_cache = createVehicle[selectRandom _cacheTypes, _cachePos, [], 0, "CAN_COLLIDE"];

	if (_debug) then {
		_markerName = format["cache_%1", _i];
		createMarker[_markerName, getPos _cache];
		_markerName setMarkerShape "ICON";
		_markerName setMarkerType "hd_dot";
		_markerName setmarkerColor "colorblue";
	};
};