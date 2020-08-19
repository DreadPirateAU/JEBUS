if (isServer) then
{
    [] spawn
    {
        while {true} do
        {
            {
                    _x addCuratorEditableObjects
                    [
                        entities [[],['Logic', 'VirtualCurator_F'],true],
                        true, //Include vehicle crew
                        true  //Exclude dead bodies
                    ];
            } count allCurators;
            sleep 1;
        };
    };
};