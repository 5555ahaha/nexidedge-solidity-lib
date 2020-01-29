pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/access/Roles.sol";
import "./MasterRole.sol";

contract PricerRole is MasterRole{
    using Roles for Roles.Role;

    event PricerAdded(address indexed account);
    event PricerRemoved(address indexed account);

    Roles.Role private _pricer;

    constructor () internal {
        _addPricer(msg.sender);
    }

    modifier onlyPricer() {
        require(isPricer(msg.sender), "PricerRole: caller does not have the Pricer role");
        _;
    }

    function isPricer(address account) public view returns (bool) {
        return _pricer.has(account);
    }

    function addPricer(address account) public onlyPricer {
        _addPricer(account);
    }

    function removePricer(address account) public onlyMaster {
        _removePricer(account);
    }

    function renouncePricer() public {
        _removePricer(msg.sender);
    }

    function _addPricer(address account) internal {
        _pricer.add(account);
        emit PricerAdded(account);
    }

    function _removePricer(address account) internal {
        _pricer.remove(account);
        emit PricerRemoved(account);
    }
}
