// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {LoginCoin} from "../src/LoginCoin.sol";
import "forge-std/Script.sol";

contract LoginCoinScript is Script {
    uint256 private constant _WAD = 1000000000000000000;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // SimpleDN404 constructor args -- name, symbol, initialSupply, owner
        // CHANGE THESE VALUES TO SUIT YOUR NEEDS
        string memory name = "LoginCoin";
        string memory symbol = "LC";

        LoginCoin c = new LoginCoin(name, symbol);

        // Mint 1000 LC to the deployer
        c.mint(address(this), 2000 * _WAD);
        vm.stopBroadcast();
    }
}