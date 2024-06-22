// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {OshigotoMembership} from "../src/OshigotoMembership.sol";
import {OshigotoToken} from "../src/OshigotoToken.sol";
import {DN404Mirror} from "../src/dn404/DN404Mirror.sol";
import "forge-std/Script.sol";

contract OshigotoMembershipScript is Script {

    OshigotoMembership public oshigotoMembership;
    OshigotoToken public oshigotoToken;
    DN404Mirror public dn404mirror;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address oshigotoTokenAddress = vm.envAddress("OSHIGOTO_TOKEN_ADDRESS");

        oshigotoMembership = new OshigotoMembership(
            "AliceMembership",
            "AM",
            "Alice",
            "https://bafybeiad4heb2zbyqgeigp5n6auz57dnk43ggm2qzkwhoxvp66dyinredm.ipfs.dweb.link/",
            oshigotoTokenAddress
        );

        oshigotoToken = OshigotoToken(payable(address(0xbF567D6f1D03EF749C9eA23422c602Bb3e350EE1)));
        dn404mirror = DN404Mirror(payable(address(oshigotoToken.mirrorERC721())));
        dn404mirror.setApprovalForAll(address(oshigotoMembership), true);
        oshigotoMembership.setMaterialContractAddress(address(dn404mirror), true);

        vm.stopBroadcast();
    }
}