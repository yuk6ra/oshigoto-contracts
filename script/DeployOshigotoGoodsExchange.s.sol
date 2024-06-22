// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {OshigotoGoodsExchange} from "../src/OshigotoGoodsExchange.sol";
import {CheckCoin} from "../src/CheckCoin.sol";
import "forge-std/Script.sol";

contract OshigotoGoodsExchangeScript is Script {
    OshigotoGoodsExchange public oshigotoGoodsExchange;
    CheckCoin public checkCoin;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory name = "Oshigoto Goods Exchange";
        string memory symbol = "OGX";
        string memory oshi_name = "Alice";
        string memory dataURI = "https://bafybeidk3siwfxbnp5jbiw7fho5rjrf4gytjejrizcydxmz2upphnrjguy.ipfs.dweb.link/";

        address owner = address(this);

        checkCoin = CheckCoin(payable(address(0x6B58eAeEfDD3C4Da5B80dc7F3F26Fdc901D40b9b)));

        oshigotoGoodsExchange = new OshigotoGoodsExchange(
            name,
            symbol,
            oshi_name,
            dataURI,
            address(checkCoin)
        );

        checkCoin.approve(address(oshigotoGoodsExchange), 1000 ether);
        vm.stopBroadcast();
    }
}