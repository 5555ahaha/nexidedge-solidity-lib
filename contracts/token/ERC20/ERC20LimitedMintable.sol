pragma solidity ^0.5.0;

import "../../../openzeppelin-lib/token/ERC20/ERC20.sol";
import "../../access/roles/LimitedMinterRole.sol";
import "../../access/roles/MaintainerRole.sol";

/**
 * @dev Extension of `ERC20` that adds a set of accounts with the `LimitedMinterRole`,
 * which have permission to mint (create) new tokens as they see fit.
 *
 * At construction, the deployer of the contract is the only minter.
 */
contract ERC20LimitedMintable is ERC20, LimitedMinterRole, MaintainerRole {
    /**
     * @dev See `ERC20._mint`.
     *
     * Requirements:
     *
     * - the caller must have the `LimitedMinterRole`.
     */

    uint256 max_mintable_amount = 50 ether;
    uint256 min_mintable_amount = 1 ether;

    event ChangeMaxMintableAmount(address indexed who, uint256 indexed new_max);
    event ChangeMinMintableAmount(address indexed who, uint256 indexed new_min);


    function limitedMint(address account, uint256 amount) public onlyLimitedMinter returns (bool) {
        require((amount <= max_mintable_amount) && (amount >= min_mintable_amount), 'ERC20 Limited: Invalid amount.');
        _mint(account, amount);
        return true;
    }


    function changeMaxMintableAmount(uint256 new_max) external onlyMaintainer returns (bool){
        max_mintable_amount = new_max * 1 ether;
        emit ChangeMaxMintableAmount(msg.sender, new_max);
        return true;
    }

    function changeMinMintableAmount(uint256 new_min) external onlyMaintainer returns (bool){
        min_mintable_amount = new_min * 1 ether;
        emit ChangeMinMintableAmount(msg.sender, new_min);
        return true;
    }

    function getMaxMintableAmount() external view returns(uint256){
        return max_mintable_amount/(1 ether);
    }

    function getMinMintableAmount() external view returns(uint256){
        return min_mintable_amount/(1 ether);
    }
}
