params [
	"_blackList"
	,["_debug", false]
];

_start = diag_tickTime;

_iedFrequency = 5;

_iedList = ["IEDLandBig_F","IEDLandSmall_F","IEDUrbanBig_F","IEDUrbanSmall_F"];
_numIEDs = 0;

for [{_xPos = 100},{_xPos < worldSize},{_xPos = _xPos + 200}] do {
	for [{_yPos = 100},{_yPos < worldSize},{_yPos = _yPos + 200}] do {
		_nearbyRoads = [_xPos, _yPos] nearRoads 100;
		
		if (count _nearbyRoads > 0) then {		
			{
				if (!(count roadsConnectedTo _x == 2)) then {
					_nearbyRoads = _nearbyRoads - [_x];
				};
				
				if (!(isNull nearestObject[_x, "House"])) then {
					_nearbyRoads = _nearbyRoads - [_x];
				};
				
				if ([getPos _x, _blackList] call jim_fnc_inBlacklist) then {
					_nearbyRoads = _nearbyRoads - [_x];
				};
			}forEach _nearbyRoads;
		};
		
		if (count _nearbyRoads > 0) then {
			_newIED = selectRandom _nearbyRoads;
			if (random 100 < _iedFrequency) then {
				[getPos _newIED, selectRandom _iedList] spawn jim_fnc_createIED;
				_numIEDs = _numIEDs + 1;
				
				if (_debug) then {
					_markerName = format["ied_%1_%2", _xPos, _yPos];
					createMarker[_markerName, getPos _newIED];
					_markerName setMarkerShape "ICON";
					_markerName setMarkerType "hd_dot";
					_markerName setmarkerColor "colorred";
				};
			};
		};
	};
};

_stop = diag_tickTime;
diag_log format ["Time to generate %1 IEDs: %2", _numIEDs,_stop - _start];