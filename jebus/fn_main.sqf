// 0 = [this, <other parameters>] spawn jebus_fnc_main;
// 0 = [this, "LIVES=",1] spawn jebus_fnc_main;

waitUntil { time > 0 };
if (!isServer) exitWith {};

private [
    "_unit"
    ,"_cacheRadius"
    ,"_debug"
    ,"_exitTrigger"
    ,"_firstLoop"
    ,"_gaiaParameter"
    ,"_gaiaZone"
    ,"_initString"
    ,"_initialDelay"
    ,"_lives"
    ,"_newGroup"
    ,"_pauseRadius"
    ,"_reduceRadius"
    ,"_respawnDelay"
    ,"_respawnDir"
    ,"_respawnMarkers"
    ,"_respawnPos"
    ,"_special"
    ,"_tmpGroup"
    ,"_tmpRespawnPos"
    ,"_tmpZone"
    ,"_trigger"
    ,"_unitGroup"
    ,"_unitSide"
    ,"_unitsInGroup"
    ,"_synchronizedObjectsList"
];
 
_unit = _this select 0;
 
// Make sure unit is a unit and not a group (Thanks to S.Crowe)
if (typeName _unit == "GROUP") then { _unit = leader _unit; };
 
_respawnPos = getPos _unit;
_respawnDir = getDir _unit;
_unitSide = side _unit;
 
_unitGroup = (group _unit);
_unitsInGroup = units _unitGroup;
 
_synchronizedObjectsList = [];
_respawnPosList = [];
_respawnPosList pushBack _respawnPos;
 
//Set up default parameters
_lives = -1;
_cacheRadius = 0;
_reduceRadius = 0;
_pauseRadius = 0;
_respawnDelay = 30;
_initialDelay = 0;
_gaiaParameter = "";
_gaiaZone = 0;
_special = "NONE";
_respawnMarkers = [];
_initString = "";
_recruit = false;
_debug = false;
 
//Get parameters
for "_parameterIndex" from 1 to (count _this - 1) do {
    switch (_this select _parameterIndex) do {
        case "LIVES=" : {_lives = _this select (_parameterIndex + 1)};
        case "DELAY=" : {_respawnDelay =  _this select (_parameterIndex + 1)};
        case "START=" : {_initialDelay = _this select (_parameterIndex + 1)};
        case "CACHE=" : {_cacheRadius =  _this select (_parameterIndex + 1)};
        case "REDUCE=" : {_reduceRadius =  _this select (_parameterIndex + 1)};
        case "GAIA_MOVE=" : {_gaiaParameter = "MOVE"; _gaiaZone = _this select (_parameterIndex + 1)};
        case "GAIA_NOFOLLOW=" : {_gaiaParameter = "NOFOLLOW"; _gaiaZone =  _this select (_parameterIndex + 1)};
        case "GAIA_FORTIFY=" : {_gaiaParameter = "FORTIFY"; _gaiaZone = _this select (_parameterIndex + 1)};
        case "FLYING" : {_special = "FLY"};
        case "RESPAWNMARKERS=" : {_respawnMarkers = _this select (_parameterIndex + 1)};
        case "PAUSE=" : {_pauseRadius = _this select (_parameterIndex + 1)};
        case "EXIT=" : {_exitTrigger = _this select (_parameterIndex + 1)};
        case "INIT=" : {_initString = _this select (_parameterIndex + 1)};
		case "RECRUIT" : {_recruit = true};
        case "DEBUG" : {_debug = true};
    };
};
 
//Add additional respawn positions where applicable
{
    _respawnPosList pushBack (getMarkerPos _x);
} forEach _respawnMarkers;
 
//Determine number of lives if passed an array
if (typeName _lives == "ARRAY") then {
    _minLives = _lives select 0;
    _maxLives = _lives select 1;
    _lives = _minLives + floor random (_maxLives - _minLives);
};
 
_syncs = synchronizedObjects _unit;
 
{
    if (_x isKindOf "EmptyDetector") then
    {
        _trigger = _x;
        if (_debug) then {systemChat "Synchronized trigger activation present"};
    }
    else
    {
        _synchronizedObjectsList append [_x];
    };
} forEach _syncs;

//Save unit data and delete
_groupData =  [_unit] call jebus_fnc_saveGroup;
[_unit] call jebus_fnc_deleteGroup;
 
_firstLoop = true;
 
//Main loop
while { _lives != 0 } do {
	sleep 1;
	
    //Wait for trigger activation (Thanks to pritchardgsd)
    if (! isNil "_trigger") then {
		waituntil {
			if (_debug && (floor ((time % 10)) == 0)) then {systemChat "Waiting for trigger activation"};
			sleep 1;
			(triggerActivated _trigger);
		};
    };
   
    if (_firstLoop && _initialDelay > 0) then {
        sleep _initialDelay;
        _firstLoop = false;
        if (_debug) then {systemChat "First Loop!"};
    };
    
    _newGroup = createGroup _unitSide;
    _newGroup setVariable ["groupInitialising", true, false];
	_displayName = str _newGroup;

    if (_debug) then {systemChat format["Spawning group: %1", _displayName]};

    _tmpRespawnPos = selectRandom _respawnPosList;
 
    while {[_tmpRespawnPos, _unitSide, _pauseRadius] call jebus_fnc_enemyInRadius} do {
        if (_debug) then {systemChat format["%1 - Enemies in pause radius", _displayName]};
        sleep 5;
    };
 
	//copyToClipboard str _groupData;
    //Spawn vehicles - spawn, disable sim, add crew, enable sim......
	_newGroup = [_groupData, _tmpRespawnPos, _special] call jebus_fnc_spawnGroup;
	
    //Initiate caching
    if ("CACHE=" in _this) then {
        [_newGroup, _cacheRadius, _debug] spawn jebus_fnc_cache;
    };
   
    //Initiate reducing
    if ("REDUCE=" in _this) then {
        [_newGroup, _reduceRadius, _debug] spawn jebus_fnc_reduce;
    };

	if (_recruit) then {
		[_newGroup, _debug] spawn jebus_fnc_recruit;
	};
	
    _newGroup allowfleeing 0;
   
    //Initiate GAIA
    if (_gaiaParameter in ["MOVE", "NOFOLLOW", "FORTIFY"]) then {
        if (_debug) then {systemChat format["%1 : %2", _newGroup, _gaiaParameter]};
        switch (typeName _gaiaZone) do {
            case "ARRAY" : {
                _tmpZone = selectRandom _gaiaZone;
                if (typeName _tmpZone == "SCALAR") then {_tmpZone = str (_tmpZone);};
            };
            case "SCALAR" : {_tmpZone = str (_gaiaZone);};
            default {_tmpZone = _gaiaZone};
        };
 
        _newGroup setVariable ["GAIA_ZONE_INTEND",[_tmpZone, _gaiaParameter], false];
    }; 
   
    //Add synchonizations and execute init string
    _proxyThis = leader _newgroup;
 
    {
        _proxyThis synchronizeObjectsAdd [_x];
    } forEach _synchronizedObjectsList;
   
    call compile format [_initString];
	
	sleep 1;
    
    //Check every 5 seconds to see if group is eliminated
    waituntil {
        sleep 5;
        {alive _x} count (units _newGroup) < 1;
    };
 
    if (_debug) then {systemChat format ["%1 eliminated. Waiting for respawn.", _displayName]};
 
    //Respawn delay
    if (typeName _respawnDelay == "ARRAY") then {
        _minTime = _respawnDelay select 0;
        _maxTime = _respawnDelay select 1;
        _tempRespawnDelay = _minTime + random (_maxTime - _minTime);
        if (_debug) then {systemChat format ["Respawn delay = %1 seconds", _tempRespawnDelay]};
        sleep _tempRespawnDelay;
    } else {
        if (_debug) then {systemChat format ["Respawn delay = %1 seconds", _respawnDelay]};
        sleep _respawnDelay;
    };
 
    //Check if exit trigger has been activated
    if (! isNil "_exitTrigger") then {
        if (triggerActivated _exitTrigger) then {
            if (_debug) then {systemChat "Exit trigger activated"};
            _lives = 1;
        };
    };
 
    _lives = _lives - 1;
 
    if (_debug) then {
        if (_lives < 0) then {systemChat "Infinite lives."} else
        {systemChat format["Lives remaining = %1", _lives]};
    };
 
    //Clean up empty groups
    {
          if ((count (units _x)) isEqualTo 0) then {
            if (isNil {_x getVariable "groupInitialising"}) then {
               deleteGroup _x;
            };
          };
     } count allGroups;
 
};
 
if (_debug) then {systemChat "Exiting script."};
