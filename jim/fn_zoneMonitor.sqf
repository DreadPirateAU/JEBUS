while {true} do {
	sleep 0.2;
	{
		_currentPlayer = _x;
		if (speed _currentPlayer < 100) then {
			_nearbyZones = nearestObjects [_currentPlayer, ["Sign_Arrow_Yellow_F"], 500];
			{
				_status = _x getVariable ["Active", true];
				if (!_status) then {
					[_x] spawn jim_fnc_zoneActivate;
					sleep 0.2;
				};
			}forEach _nearbyZones;
		};
		
	}forEach allPlayers;
};
