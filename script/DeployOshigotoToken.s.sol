// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {OshigotoToken} from "../src/OshigotoToken.sol";
import "forge-std/Script.sol";

contract OshigotoTokenScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // SimpleDN404 constructor args -- name, symbol, initialSupply, owner
        // CHANGE THESE VALUES TO SUIT YOUR NEEDS
        string memory name = "Oshigoto Token";
        string memory symbol = "OST"
        uint96 initialSupply = 0;
        address owner = address(this);

        new OshigotoToken(name, symbol, initialSupply, owner);
        vm.stopBroadcast();
    }
}