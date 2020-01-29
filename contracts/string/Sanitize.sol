pragma solidity ^0.5.0;


//TODO: da aggiorname per la versione 0.5.0

// @dev: adds before non lecters or number chars %#
contract Sanitize{

	
	function sanitize(string memory data) 
    pure 
    internal
    returns (bytes memory){
         bytes memory binary_data = bytes(data);
         bytes memory clean_data_temp = new bytes(3*binary_data.length);
         uint256 temp_index = 0; 
         for (uint256 i = 0; i < binary_data.length; i++){
             uint256 c = uint(uint8(binary_data[i]));
             if(c < 32){
                 clean_data_temp[temp_index] = 0x20;
                 temp_index++;
             } else if(((c>32) && (c < 48)) || ((c>57)&&(c<65)) || ((c>90) && (c<97)) || (c > 122)){
                 clean_data_temp[temp_index] = 0x25;
                 clean_data_temp[temp_index+1] = 0x23;
                 clean_data_temp[temp_index+2] = binary_data[i];
                 temp_index += 3;
             } else{
                 clean_data_temp[temp_index] = binary_data[i];
                 temp_index++;
             }
         }
         bytes memory clean_data = new bytes(temp_index);
         for (uint256 i=0; i<temp_index; i++){
             clean_data[i] = clean_data_temp[i];
         }
         return clean_data;
     }


}