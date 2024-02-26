// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract CounterScript is Script {
    uint256 private immutable _initialSupply = 1000000;

    function run() public {
        vm.startBroadcast();
        new Token(_initialSupply);
        vm.stopBroadcast();
    }
}
