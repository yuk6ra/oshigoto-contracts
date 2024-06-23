// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {CheckCoin} from "../src/CheckCoin.sol";
import "forge-std/Script.sol";

contract CheckCoinScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory name = "CheckCoin";
        string memory symbol = "CC";
        CheckCoin c = new CheckCoin(name, symbol);
        vm.stopBroadcast();
    }
}