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
        vm.startBroadcast(deployerPrivateKey);

        string memory name = "Oshigoto Token";
        string memory symbol = "OST";
        uint96 initialSupply = 0;
        address owner = address(this);

        oshigotoToken = new OshigotoToken(name, symbol, initialSupply, owner);
        checkCoin = CheckCoin(payable(address(0x6B58eAeEfDD3C4Da5B80dc7F3F26Fdc901D40b9b)));
        oshigotoToken.setPaymentTokenAddress(address(checkCoin));
        // checkCoin.approve(address(oshigotoToken), 1000);
        vm.stopBroadcast();
    }
}