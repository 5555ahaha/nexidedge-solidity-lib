pragma solidity ^0.5.0;

import "../../../openzeppelin-lib/access/roles/PauserRole.sol";
import "./MasterRole.sol";

contract AdvancedPauserRole is PauserRole, MasterRole{

	function removePauser(address account) public onlyMaster {
		_removePauser(account);
	}
}