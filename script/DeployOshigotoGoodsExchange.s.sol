// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {OshigotoGoodsExchange} from "../src/OshigotoGoodsExchange.sol";
import {OshigotoToken} from "../src/OshigotoToken.sol";
import "forge-std/Script.sol";

contract OshigotoGoodsExchangeScript is Script {
    OshigotoGoodsExchange public oshigotoGoodsExchange;
    OshigotoToken public oshigotoToken;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory name = "Oshigoto Goods Exchange";
        string memory symbol = "OGX";
        string memory oshi_name = "Alice";
        string memory dataURI = "https://bafybeidk3siwfxbnp5jbiw7fho5rjrf4gytjejrizcydxmz2upphnrjguy.ipfs.dweb.link/";

        address oshigotoTokenAddress = vm.envAddress("OSHIGOTO_TOKEN_ADDRESS");

        oshigotoGoodsExchange = new OshigotoGoodsExchange(
            name,
            symbol,
            oshi_name,
            dataURI,
            address(oshigotoTokenAddress) // Payment token address
        );

        oshigotoToken = OshigotoToken(payable(address(oshigotoTokenAddress)));

        oshigotoToken.approve(address(oshigotoGoodsExchange), 1 ether);
        vm.stopBroadcast();
    }
}