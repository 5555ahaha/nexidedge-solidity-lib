pragma solidity ^0.5.0;

interface IERC20Affordable {
	
	function set_erc20_address(address _instance) external onlyMaintainer returns (bool);
	function get_erc20_address() external onlyMaintainer returns (address);
	function set_receiver_address(address payable new_address) external onlyMaintainer returns(bool);
	function get_receiver_address() external onlyMaintainer returns(address);
	function afford(address account, uint256 amount) public payable returns (bool);
}