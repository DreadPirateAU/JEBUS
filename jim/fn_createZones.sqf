#include "excludedHouses.hpp"

params ["_blackList"];

_start = diag_tickTime;

for "_xPos" from 100 to worldSize step 200 do {
	for "_yPos" from 100 to worldSize step 200 do {
		_nearbyHouses = nearestObjects [[_xPos, _yPos], ["House"], 100];
		if (count _nearbyHouses > 0) then {
			{
				if (
					(count (_x buildingPos -1) < 1) ||
					{typeOf(_x) in _excludedHouses} ||
					{[getPos _x, _blackList] call jim_fnc_inBlacklist}
				) then {
					_nearbyHouses = _nearbyHouses - [_x];
				};
			} forEach _nearbyHouses;
		};
		if (count _nearbyHouses > 2) then {
			_markerName = format ["eos_%1_%2", _xPos, _yPos];
			createMarker[_markerName, [_xPos, _yPos]];
			_markerName setMarkerShape "rectangle";
			_markerName setMarkerSize [100, 100];
			_markerName setMarkerColor "ColorEAST";
			_markerName setMarkerAlpha 0.5;
			_zone = createVehicle["Sign_Arrow_Yellow_F", [_xPos, _yPos], [], 0, "CAN_COLLIDE"];
			_zone setVariable ["Active", false];
			_zone setVariable ["Marker", _markerName];
			_buildingPositions = [];
			{
				_buildingPositions append (_x buildingPos -1);
			} forEach _nearbyHouses;
			_zone setVariable ["BuildingPositions", _buildingPositions];
		};
	};
};

_stop = diag_tickTime;
diag_log format ["Time to generate Zones: %1",_stop - _start];