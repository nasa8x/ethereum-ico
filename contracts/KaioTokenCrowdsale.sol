pragma solidity ^0.4.18;

import "./zeppelin/contracts/crowdsale/CappedCrowdsale.sol";
import "./zeppelin/contracts/crowdsale/RefundableCrowdsale.sol";
import "./KaioToken.sol";

contract KaioTokenCrowdsale is CappedCrowdsale, RefundableCrowdsale {
    
    uint256 public constant BOUNTY_SHARE = 10;
    uint256 public constant CROWDSALE_SHARE = 40;
    uint256 public constant FOUNDATION_SHARE = 50;

    // price at which whitelisted buyers will be able to buy tokens
    uint256 public whiteListBonus;
    uint256 public fromBonus;
    uint256 public toBonus;

      // list of addresses that can purchase before crowdsale opens
    mapping (address => bool) public whitelist;
      // customize the rate for each whitelisted buyer
    mapping (address => uint256) public buyerRate;
   
    function KaioTokenCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _whiteListBonus, uint256 _fromBonus, uint256 _toBonus, uint256 _goal, uint256 _cap, address _wallet) public
        CappedCrowdsale(_cap)     
        RefundableCrowdsale(_goal)
        Crowdsale(_startTime, _endTime, _rate, _wallet)
    {
        //As goal needs to be met for a successful crowdsale
        //the value needs to less or equal than a cap which is limit for accepted funds
       require(_goal <= _cap);

       whiteListBonus = _whiteListBonus;
       fromBonus = _fromBonus;
       toBonus = _toBonus;

    }

    function createTokenContract() internal returns (MintableToken) {
        return new KaioToken();
    }

    function addToWhitelist(address buyer) public onlyOwner {
        require(buyer != 0x0);
        whitelist[buyer] = true; 
    }

    // @return true if buyer is whitelisted
    function isWhitelisted(address buyer) public constant returns (bool) {
        return whitelist[buyer];
    }

    // function rateNow() public constant returns (uint256) {
    //     return getRate();
    // }

    function getRate() private returns(uint256) {
        // some early buyers are offered a discount on the crowdsale price
        if (buyerRate[msg.sender] != 0) {
            return buyerRate[msg.sender];
        }

        // whitelisted buyers can purchase at preferential price before crowdsale ends
        if (isWhitelisted(msg.sender)) {
            return rate + (rate * whiteListBonus/100);
        }

        // otherwise compute the price for the auction
        uint256 elapsed = block.timestamp - startTime;        
        uint256 t = endTime - startTime;
        uint256 f = rate + (rate * fromBonus/100);
        uint256 r = f - (rate + (rate * toBonus/100));

        return f.sub(r.mul(elapsed).div(t));
        
    }

    // low level token purchase function
    function buyTokens(address beneficiary) payable {
        require(beneficiary != 0x0);
        require(validPurchase());

        uint256 weiAmount = msg.value;
      
        uint256 rate = getRate();
        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(rate);

        // update state
        weiRaised.add(weiAmount);

        token.mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }
    
}