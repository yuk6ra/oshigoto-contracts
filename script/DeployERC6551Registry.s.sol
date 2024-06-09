// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ERC6551Registry, IERC6551Registry} from "../src/ERC6551Registry.sol";
import "forge-std/Script.sol";

contract ERC6551RegistryScript is Script {
    uint256 private constant _WAD = 1000000000000000000;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        IERC6551Registry e = new ERC6551Registry();

        vm.stopBroadcast();
    }
}