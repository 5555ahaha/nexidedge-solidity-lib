pragma solidity ^0.5.0;

import "./ERC20Affordable.sol";
import "./IDalyaCoin.sol";

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
contract ERC20Discountable is ERCO20Affordable{

    /**
    * @dev Struct to define the type of discount to apply
    * add_receiver: the address of the person who will receive the discount
    ** if add_receiver == Address(0) anyone can receive the discount
    * amount: if there is a fixed amount of token discounted. If zero, no limit.
    * starting_date: the block.timestamp of the begin of the discount. If zero, starts now
    * ending_date: the block.timestamp of the end of the discount. If zero, it never ends
    * one_shot: if true you can use it just once
    */
    struct Discount{
        address add_receiver;  
        uint256 amount;
        uint256 price;
        uint starting_date;
        uint ending_date;
        bool one_shot;
        bool enabled;
    }

    mapping (uint256 => Discount) discounts_list;

    event NewDiscount(address indexed who, uint256 indexed discount_code);
    event DeleteDiscount(address indexed who, uint256 indexed discount_code);
    event AffordDiscount(address indexed who, uint256 indexed discount_code, uint256 indexed amount);

    /**
     * @dev See `ERC20._mint`.
     *
     * Requirements:
     *
     * amount: integer number of token to buy. Thus in this case, if you want to buy 1 token
     ** you set amount = 1 and not amount = 1*10^18
     */
    function afford_discount(address account, uint256 amount, uint256 discount_code) external returns (bool) {
        (uint256 fee_to_pay, uint256 real_amount) = calculate_fee_discount(amount, discount_code);
        require(fee_to_pay == msg.value, 'Fees are not correct');
        require(payment_receiver != address(0), "You can't buy tokens right now.");
        require(erc20instance != address(0), "ERC20 not initialized");
        require(discounts_list[discount_code].enabled == true, "Discount code is not valid.");
        // Impedisco di usare più volte lo stesso codice che può essere usato una volta sola
        if(discounts_list[discount_code].one_shot == true){
            discounts_list[discount_code].enabled = false;
        }
        payment_receiver.transfer(msg.value);
        IDalyaCoin(erc20instance).mint(account, real_amount * 1 ether);
        emit AffordDiscount(msg.sender, discount_code, real_amount);
        return true;
    }
    
    // Le funzioni overload nella suite di test, mi incasina abbastanza le cose perchè per chiamare le funzioni devo fare
    // t.calculate_fee.methods. A questo punto ho una dict che mi elenca i metodi possibili da chiamare che a quel punto chiamerò
    // con qualcosa del tipo t.calculate_fee.methods['uint,uint'](1,2)
    // Quindi preferisco rimuoverle
    function calculate_fee_discount(uint256 amount, uint256 discount_code) public view returns(uint256, uint256){
        uint256 real_amount;
        uint256 price = discounts_list[discount_code].price;
        if (discounts_list[discount_code].add_receiver != address(0)){
            require(msg.sender == discounts_list[discount_code].add_receiver, "You can't benefit from the discount.");
        }
        if(discounts_list[discount_code].amount != 0){
            real_amount = discounts_list[discount_code].amount;
        } else{
            real_amount = amount;
        }
        if (discounts_list[discount_code].starting_date != 0){
            require(block.timestamp >= discounts_list[discount_code].starting_date, 'Discount period is not begun yet.');
        }
        if (discounts_list[discount_code].ending_date != 0){
            require(block.timestamp <= discounts_list[discount_code].ending_date, 'Discount period is over.');
        }
        uint256 fee = price * real_amount;
        return (fee, real_amount);

    }

    function add_discount(uint256 discount_code, address add_receiver, uint256 amount, uint256 price, uint starting_date, uint ending_date, bool one_shot) public onlyPricer returns(bool){
        Discount memory discount;
        discount.add_receiver = add_receiver;
        discount.amount = amount;
        discount.price = price;
        discount.starting_date = starting_date;
        discount.ending_date = ending_date;
        discount.one_shot = one_shot;
        discount.enabled = true;
        discounts_list[discount_code] = discount;
        emit NewDiscount(msg.sender, discount_code);
        return true;
    }

    function del_discount(uint256 discount_code) public onlyPricer returns(bool){
        delete discounts_list[discount_code];
        return true;
    }

    function get_discount(uint256 discount_code) public view returns(address, uint256, uint256, uint, uint, bool){
        return (discounts_list[discount_code].add_receiver, 
            discounts_list[discount_code].amount, 
            discounts_list[discount_code].price, 
            discounts_list[discount_code].starting_date, 
            discounts_list[discount_code].ending_date, 
            discounts_list[discount_code].one_shot);
    }
}
