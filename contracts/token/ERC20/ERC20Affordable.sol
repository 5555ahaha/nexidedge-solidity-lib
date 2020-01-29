pragma solidity ^0.5.0;

import "../../access/roles/PricerRole.sol";
import '../../access/roles/MaintainerRole.sol';
import '../../token/ERC20/IERC20Affordable.sol';


/**
 * @dev Extension of `ERC20` that adds a set of accounts with the `PricerRole`,
 * which have permission to mint (create) new tokens as they see fit.
 *
 * At construction, the deployer of the contract is the only Pricer.
 *
 * PAY ATTENTION
 * The fees per token unit are calculated considering 'amount' 1 token = 10^18 unity
 * The resulting fees are in wei
 */
contract ERC20Affordable is IDalyaCoin, PricerRole, MaintainerRole {
    

    uint256[4] fee_levels_per_unit = [0.005 ether, 0.0045 ether, 0.004 ether, 0.0035 ether];
    uint256[3] fee_levels_amount =  [200, 500, 1000];

    address payable payment_receiver = address(0);
    address erc20instance = address(0); //vedere se fare private con getter e setter


    event ChangeFeePerUnit(address indexed who);
    event ChangeFeeAmount(address indexed who);
    event ChangePaymentReceiver(address indexed from, address indexed new_address);
    event Afford(address indexed who, address indexed to, uint256 amount);

    /**
     * @dev See `ERC20._mint`.
     *
     * Requirements:
     *
     * amount: integer number of token to buy. Thus in this case, if you want to buy 1 token
     ** you set amount = 1 and not amount = 1*10^18
     */
    function afford(address account, uint256 amount) public payable returns (bool) {
        uint256 fee_to_pay = calculate_fee(amount);
        require(fee_to_pay == msg.value, 'Fees are not correct');
        require(payment_receiver != address(0), "You can't buy tokens right now.");
        payment_receiver.transfer(msg.value);
        IDalyaCoin(erc20instance).mint(account, amount * 1 ether);
        emit Afford(msg.sender, account, amount);
        return true;
    }

    //settata come internal chiamata da discount
    function set_receiver_address(address payable new_address) external onlyMaintainer returns(bool){
        payment_receiver = new_address;
        emit ChangePaymentReceiver(msg.sender, new_address);
        return true;
    }

    function get_receiver_address() external onlyMaintainer returns(address){
        return payment_receiver;
    }

    function calculate_fee(uint256 amount) public view returns(uint256){
        if (amount < fee_levels_amount[0]){
            
            return amount*fee_levels_per_unit[0];
        
        } else if((amount >= fee_levels_amount[0]) && (amount < fee_levels_amount[1])){
            
            return amount*fee_levels_per_unit[1];
        
        }  else if((amount >= fee_levels_amount[1]) && (amount < fee_levels_amount[2])){
            
            return amount*fee_levels_per_unit[2];
        
        }  else if((amount >= fee_levels_amount[2])) {
            
            return amount*fee_levels_per_unit[3];
        }
    }

    function change_fee_per_unit(uint256[4] calldata new_fee ) external onlyPricer returns (bool){
        emit ChangeFeePerUnit(msg.sender);
        fee_levels_per_unit = new_fee;
        return true;
    }

    function change_fee_amount(uint256[3] calldata new_fee ) external onlyPricer returns (bool){
        emit ChangeFeeAmount(msg.sender);
        fee_levels_amount = new_fee;
        return true;
    }

    function get_fee_per_unit() external view returns(uint256[4] memory){
        return fee_levels_per_unit;
    }

    function get_fee_amount() external view returns(uint256[3] memory){
        return fee_levels_amount;
    }
}
