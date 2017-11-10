pragma solidity ^0.4.18;

import "./zeppelin/contracts/token/MintableToken.sol";

contract KaioToken is MintableToken {
    string public name = "KaioToken"; 
    string public symbol = "KAI";
    uint public decimals = 18;

}