// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {OshigotoMembership} from "../src/OshigotoMembership.sol";
import "forge-std/Script.sol";

contract OshigotoMembershipScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        OshigotoMembership c = new OshigotoMembership(
            "AliceMembership",
            "AM",
            "Alice"
        );

        vm.stopBroadcast();
    }
}