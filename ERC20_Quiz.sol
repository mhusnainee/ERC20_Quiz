// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20_Quiz is ERC20, Ownable
{

    uint public price = 10**18;
    uint public BuyLimit = 5;
    mapping(address => uint) Limits;

    /**
     * @dev Initializes the Token name, Symbol and contract setting the deployer as the initial owner.
     */
    constructor() ERC20("IECToken", "IEC") {}

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     * Only owner can call this function.
     * - `account` cannot be the zero address.
     */
    function mint(address _to, uint _amount) public onlyOwner{
        _mint(_to, _amount);
    }

    /** @dev Sets Token buy limit by setting value of `BuyLimit` variable.
     *
     * Requirements:
     *
     * Only owner can call this funtion.
     */
    function setBuyLimit(uint _limit) public onlyOwner
    {
        BuyLimit = _limit;
    }

    /** @dev Changes price of Token and sets to new price in Ethers.
     *
     * Requirements:
     *
     * Only owner can call this function.
     */
    function changePrice(uint _newPriceInEthers) public onlyOwner
    {
        price = _newPriceInEthers*10**18;
    }

    /** @dev Anyone can Buy Tokens except the owner.
     * Price in Ethers will be sent in the owners acccount (address).
     *
     * Requirements:
     *
     * Owner can not call this function.
     * Buyer have to send exact price of Tokens in Ethers, not less and not more.
     * Owner should have Tokens which a Buyer can buy.
     * If a Buyer's Limit is exceeded, He can not buy tokens further.
     */
    function BuyToken(uint _amount) public payable
    {
        require(msg.sender != owner(), "Owner can not buy Tokens");
        require(msg.value == _amount*10**18, "Send exact price of IEC token");
        require(balanceOf(owner()) >= _amount, "Owner don't have enough Tokens");
        require(Limits[msg.sender] < BuyLimit, "Limit exceeded");
        _transfer(owner(), msg.sender, _amount);
        payable(owner()).transfer(msg.value);
        Limits[msg.sender] += _amount;
    }

}