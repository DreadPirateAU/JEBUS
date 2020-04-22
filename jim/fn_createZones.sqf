#include "excludedHouses.hpp"

_blackList = "Base";

for "_xPos" from 50 to worldSize step 100 do {
	for "_yPos" from 50 to worldSize step 100 do {
		_nearbyHouses = nearestObjects [[_xPos, _yPos], ["House"], 70];
		{
			if (
				(count (_x buildingPos -1) < 1) ||
				(mapGridPosition _x != mapGridPosition [_xPos, _yPos] )||
				(typeOf(_x) in _excludedHouses) ||
				(position _x inArea _blackList)
			) then {
				_nearbyHouses = _nearbyHouses - [_x];
			};
		} forEach _nearbyHouses;
		if (count _nearbyHouses > 0) then {
			_markerName = format ["eos_%1_%2", _xPos, _yPos];
			createMarker[_markerName, [_xPos, _yPos]];
			_markerName setMarkerShape "rectangle";
			_markerName setMarkerSize [50, 50];
			_markerName setMarkerColor "ColorEAST";
			_markerName setMarkerAlpha 0.5;
			_location = createVehicle["Sign_Arrow_Yellow_F", [_xPos, _yPos], [], 0, "CAN_COLLIDE"];
			_location setVariable ["Active", false];
			_location setVariable ["Marker", _markerName];
		};
	};
};