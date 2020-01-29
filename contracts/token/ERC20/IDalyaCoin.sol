pragma solidity ^0.5.0;

interface IDalyaCoin {

	function limitedMint(address account, uint256 amount) public returns (bool);
	//PROVARE SENZA MODIFICATORE E LASCIARLO NELL'IMPLEMENTAZIONE, UGUALE CON PAYABLE
	function mint(address account, uint256 amount) public returns (bool);

}