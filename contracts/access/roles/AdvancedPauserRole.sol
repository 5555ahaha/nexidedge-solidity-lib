pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/access/roles/PauserRole.sol";
import "./MasterRole.sol";

contract AdvancedPauserRole is PauserRole, MasterRole{

	function removePauser(address account) public onlyMaster {
		_removePauser(account);
	}
}