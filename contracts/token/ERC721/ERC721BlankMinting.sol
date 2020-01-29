pragma solidity ^0.5.0;

import "../../../openzeppelin-lib/token/ERC721/ERC721.sol";


contract ERC721BlankMinting is ERC721{

	function blank_mint(address _to, uint256 _tokenId) public returns (bool){
		return _blank_mint(_to, _tokenId);
	}


	function _blank_mint(address _to, uint256 _tokenId) internal returns (bool){
    	super._mint(_to, _tokenId);
    	_blank_token(_to, _tokenId);
    	return true;
    }

    function _blank_token(address _creator, uint256 _tokenId) internal returns(bool);
}