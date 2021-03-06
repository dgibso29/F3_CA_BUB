
#include "macros.hpp"

SERVER_ONLY;


if (isNil "f_arr_aiCaching_playerClusters") then
{
    f_arr_aiCaching_playerClusters = [];
};

if (isNil "f_arr_aiCaching_playerClustersTemp") then
{
    f_arr_aiCaching_playerClustersTemp = [];
};



_isPointWithinCluster =
{
    params ["_point", "_cluster"];

    _centroid = _cluster select 0;
    _distance = _centroid distance2D _point;

    (_distance <= f_var_aiCaching_clusterRadius)

};



_addPlayerToCluster =
{
    params ["_ply", "_cluster"];

    _centroid = _cluster select 0;
    _playerList = _cluster select 1;

    _playerList pushBack _ply;
    _x setVariable ["f_var_aiCaching_cluster", _cluster];

    _count = count _playerList;

    _centroid = (_centroid vectorMultiply ((_count-1) / _count)) vectorAdd (getPos _ply vectorMultiply (1 / _count));

    _cluster set [0, _centroid];

};



_createVehicleCluster =
{
    params ["_ply"];

    _vehicle = vehicle _ply;
    _cluster = [[0,0,0], [], _vehicle];

    _crew = crew _vehicle;

    {
        [_x, _cluster] call _addPlayerToCluster;
    } forEach _crew;

    _cluster

};



_clusterThisPlayer =
{
    params ["_ply"];

    if (vehicle _ply != _ply) exitWith
    {
        _cluster = [_ply] call _createVehicleCluster;
		f_arr_aiCaching_playerClustersTemp pushBack _cluster;
		_cluster
    };

    _pos = getPos _ply;

    _cluster =
    {
        if ([_pos, _x] call _isPointWithinCluster) exitWith { _x };
    } forEach f_arr_aiCaching_playerClustersTemp;

    if (isNil '_cluster') then
    {
        _cluster = [[0,0,0], [], objNull];
        f_arr_aiCaching_playerClustersTemp pushBack _cluster;
    };

    [_ply, _cluster] call _addPlayerToCluster;

    _cluster

};



_agenda = allPlayers;
f_arr_aiCaching_playerClustersTemp = [];

{
    _x setVariable ["f_var_aiCaching_cluster", []];
} forEach _agenda;

{
    _playerCluster = _x getVariable ["f_var_aiCaching_cluster", []];

    if (_playerCluster isEqualTo []) then
    {
        [_x] call _clusterThisPlayer;
    };

} forEach _agenda;

f_arr_aiCaching_playerClusters = f_arr_aiCaching_playerClustersTemp;
