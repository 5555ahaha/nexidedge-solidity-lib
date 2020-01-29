pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/access/roles/MinterRole.sol";
import "./MasterRole.sol";

contract AdvancedMinterRole is MinterRole, MasterRole{

    function removeMinter(address account) public onlyMaster {
        _removeMinter(account);
    }
}