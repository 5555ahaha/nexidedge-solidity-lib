// Ruolo per il Minter che può coniare un tot di moneta alla volta al massimo
// Solo chi è LimitedMinter e Maintainer può togliere un LimitedMinter dall'elenco

pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/access/Roles.sol";
import "./MasterRole.sol";

contract LimitedMinterRole is MasterRole{
    using Roles for Roles.Role;

    event LimitedMinterAdded(address indexed account);
    event LimitedMinterRemoved(address indexed account);

    Roles.Role private _limitedminters;

    constructor () internal {
        _addLimitedMinter(msg.sender);
    }

    modifier onlyLimitedMinter() {
        require(isLimitedMinter(msg.sender), "LimitedMinterRole: caller does not have the LimitedMinter role");
        _;
    }

    function isLimitedMinter(address account) public view returns (bool) {
        return _limitedminters.has(account);
    }

    function addLimitedMinter(address account) public onlyLimitedMinter {
        _addLimitedMinter(account);
    }

    function renounceLimitedMinter() public {
        _removeLimitedMinter(msg.sender);
    }

    function removeLimitedMinter(address account) public onlyMaster {
        _removeLimitedMinter(account);
    }

    function _addLimitedMinter(address account) internal {
        _limitedminters.add(account);
        emit LimitedMinterAdded(account);
    }

    function _removeLimitedMinter(address account) internal {
        _limitedminters.remove(account);
        emit LimitedMinterRemoved(account);
    }
}
