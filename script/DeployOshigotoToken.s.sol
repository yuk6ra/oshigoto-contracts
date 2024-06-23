// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {OshigotoToken} from "../src/OshigotoToken.sol";
import {CheckCoin} from "../src/CheckCoin.sol";
import "forge-std/Script.sol";

contract OshigotoTokenScript is Script {
    OshigotoToken public oshigotoToken;
    CheckCoin public checkCoin;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        address checkcoinAddress = vm.envAddress("CHECKCOIN_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        string memory name = "Oshigoto Token";
        string memory symbol = "OST";
        string memory oshi_name = "Alice";
        uint96 initialSupply = 0;
        address owner = address(this);

        oshigotoToken = new OshigotoToken(
            name,
            symbol,
            oshi_name,
            initialSupply,
            owner
        );
        checkCoin = CheckCoin(payable(address(checkcoinAddress)));
        oshigotoToken.setPaymentTokenAddress(address(checkCoin));
        checkCoin.approve(address(oshigotoToken), 1000 ether);
        vm.stopBroadcast();
    }
}