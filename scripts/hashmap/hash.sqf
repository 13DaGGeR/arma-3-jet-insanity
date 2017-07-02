/*
 * Name:	hashmap
 * Date:	01.05.2017
 * Version: 1.0
 * Author:  13dagger
 *
 * Description:
 * hashmap library
 *
 * Parameter(s):
 * _string (String): - string to hash.
  */

scriptName "hashmap";

params ["_string"];
private ["_hash", "_i","_len","_max"];

_len=4;
_max=(10^(_len-1)) - 1;
_hash=0;
_i=0;
{
	_hash=_hash+(_x*(10^_i));
	_i=_i+1;
	if(_hash>_max)then{
		_hash=_hash-_max;
		_i=0;
	};
}foreach toArray(_string);

_hash;
