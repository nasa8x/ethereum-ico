pragma solidity ^0.4.18;

import "./zeppelin/contracts/crowdsale/RefundableCrowdsale.sol";
import "./zeppelin/contracts/crowdsale/CappedCrowdsale.sol";
import "./KaioToken.sol";

contract KaioTokenCrowdsale is CappedCrowdsale, RefundableCrowdsale {
    
    
    // total token supply: 1B
    uint256 public constant TOTAL_SUPPLY = 10000 * (10 ** 18); // 1b    
    uint256 public constant CROWDSALE_SUPPLY = 4000 * (10 ** 18); // 400m
    uint256 public constant PRESALE_SUPPLY = 1000 * (10 ** 18); // 100m

    // bonus for whitelist from 40% to 30%
    uint256 public constant PRESALE_BONUS_MAX = 40;
    uint256 public constant PRESALE_BONUS_MIN = 30;
    uint256 public constant PRESALE_DAYS = 30 minutes; // 7 days 

    // bonus for public crowdsale from 20% to 5%
    uint256 public constant PUBLIC_CROWDSALE_BONUS_MAX = 20; 
    uint256 public constant PUBLIC_CROWDSALE_BONUS_MIN = 5;
    
    uint256 public constant PUBLIC_INVEST_MIN = 1 ether / 2;
    uint256 public constant PUBLIC_INVEST_MAX = 300 ether;

    uint256 public constant PRESALE_INVEST_MIN = 1 ether; // 50 ether
    uint256 public constant PRESALE_INVEST_MAX = 3000 ether; 

    uint256 public constant GOAL = 1 ether;
    uint256 public constant CAP = 2 ether;
       
    uint256 public presaleTime;
    uint256 public tokenRaised;

     // list of addresses that can purchase before crowdsale opens
    mapping (address => bool) public whitelist;    
   
    function KaioTokenCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)   
        CappedCrowdsale(CAP)        
        RefundableCrowdsale(GOAL)     
        Crowdsale(_startTime, _endTime, _rate, _wallet)
    {
        presaleTime = _startTime.add(PRESALE_DAYS);    

    }

    function createTokenContract() internal returns (MintableToken) {
        return new KaioToken();
    }

    function addToWhitelist(address buyer) public onlyOwner {
        require(buyer != 0x0);
        whitelist[buyer] = true; 
    }

     function addToWhitelists(address[] buyers) public onlyOwner {
        require(buyers.length > 0);
        for(uint256 i = 0; i < buyers.length; i++) {
            address b = buyers[i];
            whitelist[b] = true;            
        }
    }

    // @return true if buyer is whitelisted
    function isWhitelisted(address buyer) public constant returns (bool) {
        return whitelist[buyer];
    }


    // In case you want to divide the programs into phases
    function restart(uint256 _startTime, uint256 _endTime, uint256 _rate) public onlyOwner {
       startTime = _startTime;
       endTime = _endTime;
       rate = _rate;       
    }

    // Pay for affiliate marketing programs
    function reward(address a, uint256 amount) public onlyOwner {
        token.mint(a, amount);
    }      

    // calculate token amount to be created
    function calc(uint256 val) public constant returns(uint256) {
        
         // otherwise compute the price for the auction block.timestamp        
        uint256 t; uint256 f; uint256 r; uint256 elapsed;      
       
        // whitelisted buyers can purchase at preferential price before crowdsale ends
        if (now >= startTime && now <= presaleTime && tokenRaised < PRESALE_SUPPLY && isWhitelisted(msg.sender) && val >= PRESALE_INVEST_MIN && val <= PRESALE_INVEST_MAX) {
            elapsed = now - startTime;
            t = presaleTime - startTime;
            f = rate.add(rate.mul(PRESALE_BONUS_MAX).div(100)); //rate + (rate * PRESALE_BONUS_MAX/100);
            r = f.sub(rate.add(rate.mul(PRESALE_BONUS_MIN).div(100))); //f - (rate + (rate * PRESALE_BONUS_MIN/100));   
            return val.mul(f.sub(r.mul(elapsed).div(t)));                    
        }else if (now > presaleTime && now <= endTime && tokenRaised < CROWDSALE_SUPPLY && val >= PUBLIC_INVEST_MIN && val <= PUBLIC_INVEST_MAX) {
            elapsed = now - presaleTime;
            t = endTime - presaleTime;       
            f = rate.add(rate.mul(PUBLIC_CROWDSALE_BONUS_MAX).div(100)); 
            r = f.sub(rate.add(rate.mul(PUBLIC_CROWDSALE_BONUS_MIN).div(100))); 
            return val.mul(f.sub(r.mul(elapsed).div(t)));
        }
       
        return 0;       
        
    }

    // low level token purchase function
    function buyTokens(address add) payable {
        require(add != 0x0);
        require(validPurchase());        

        uint256 val = msg.value;
        // calculate token amount to be created
        uint256 tokens = calc(val);

        require(tokens > 0);

        // update state
        weiRaised.add(val);
        tokenRaised.add(tokens);
        
        token.mint(add, tokens);
        TokenPurchase(msg.sender, add, val, tokens);

        forwardFunds();
    }

     function finalization() internal {
        uint256 t = token.totalSupply();
        uint256 extant = TOTAL_SUPPLY.sub(t);

        // emit tokens for the foundation
        token.mint(wallet, extant);       
    }

    
    
}