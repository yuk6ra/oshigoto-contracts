// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OshigotoToken} from "../src/OshigotoToken.sol";
import {LoginCoin} from "../src/LoginCoin.sol";
import {DN404Mirror} from "../src/dn404/DN404Mirror.sol";
import {OshigotoMembership} from "../src/OshigotoMembership.sol";

contract OshigotoMembershipTest is Test {
    OshigotoToken public oshigotoToken;
    OshigotoMembership public oshigotoMembership;
    address alice = address(1289931);

    LoginCoin loginCoin;
    DN404Mirror public dn404mirror;

    uint96 initialTokenSupply = 1*10**18;

    function setUp() public {

        vm.startPrank(alice);
        oshigotoToken = new OshigotoToken("DN404", "DN", initialTokenSupply, address(this));
        dn404mirror = DN404Mirror(payable(address(oshigotoToken.mirrorERC721())));
        loginCoin = new LoginCoin("LoginCoin", "LC");

        oshigotoMembership = new OshigotoMembership(
            "AliceMembership",
            "AM",
            "Alice",
            "https://bafybeig7wwdixqpzaqoxvbagbfxjbzgljzdgwgnufekrwtjeb7cjjvu7n4.ipfs.dweb.link/",
            address(oshigotoToken)
        );
        vm.stopPrank();
    }

    function testLevelup() public {

        vm.prank(alice);
        oshigotoToken.setPriceWithNativeToken(0.01 ether);


        uint256 nftMint = 6;
        for (uint i = 1; i <= nftMint*2; i++) {
            oshigotoToken.mintWithNativeToken{value: 0.01 ether}(alice);
        }
        uint256 tokenId = 3;

        console.log("totalSupply: ", oshigotoToken.totalSupply());

        console.log("rankOf: ", oshigotoToken.rankOf(1));
        console.log("ownerOf 1: ", dn404mirror.ownerOf(1));

        vm.prank(alice);
        oshigotoMembership.mintMembership();
        console.log("totalSupply: ", oshigotoMembership.totalSupply());
        console.log("Membership owner: ", oshigotoMembership.ownerOf(0));

        vm.prank(alice);
        oshigotoMembership.setMaterialContractAddress(address(oshigotoToken), true);

        // Approve
        vm.prank(alice);
        dn404mirror.setApprovalForAll(address(oshigotoMembership), true);

        console.log(msg.sender);
        console.log(oshigotoMembership.ownerOf(0));

        vm.prank(alice);
        oshigotoMembership.levelUp(0, tokenId, address(oshigotoToken));

        console.log("burnPointOf: ", oshigotoMembership.burnPointOf(0));
        console.log("lastBurned: ", oshigotoMembership.lastBurnedOf(0));
    }
}