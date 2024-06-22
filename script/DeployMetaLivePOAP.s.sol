// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {LoginCoin} from "../src/LoginCoin.sol";
import "forge-std/Script.sol";

contract LoginCoinScript is Script {
    uint256 private constant _WAD = 1000000000000000000;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory name = "Alice's MetaLivePOAP";
        string memory symbol = "AMP";
        string memory oshi_name = "Alice";
        string memory dataURI = "https://bafybeieklqkfqld5r7gv4kfjoryvypxmx2rwqektc7k2dg2rermsqm3gjq.ipfs.dweb.link/";

        metaLivePOAP = new MetaLivePOAP(
            name, 
            symbol,
            oshi_name,
            dataURI
        );

        vm.stopBroadcast();
    }
}