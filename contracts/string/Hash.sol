pragma solidity ^0.5.0;

contract Hash{

function hash_string_to_bytes(string memory s) 
	pure 
	internal
	returns (bytes32 result32) {
        bytes memory b = bytes(s);
        uint i;
        uint256 result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 16 + (c - 48);
            } else if (c>=97 && c<=102){
                result = result *16 +(c-87);
            }
        }
        result32=bytes32(result);
    }

}