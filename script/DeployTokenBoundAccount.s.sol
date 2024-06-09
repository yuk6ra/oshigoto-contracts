// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ERC6551Account} from "../src/TokenBoundAccount.sol";
import "forge-std/Script.sol";

contract TokenBoundAccountScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ERC6551Account c = new ERC6551Account();

        vm.stopBroadcast();
    }
}