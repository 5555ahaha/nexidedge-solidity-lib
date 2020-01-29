pragma solidity ^0.5.0;

import "../../../openzeppelin-lib/access/roles/MinterRole.sol";
import "./MasterRole.sol";

contract AdvancedMinterRole is MinterRole, MasterRole{

    function removeMinter(address account) public onlyMaster {
        _removeMinter(account);
    }
}