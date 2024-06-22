// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MetaLivePOAP} from "../src/MetaLivePOAP.sol";

contract MetaLivePOAPTest is Test {
    address alice = address(111);
    MetaLivePOAP public metaLivePOAP;

    function setUp() public {
        vm.startPrank(alice);

        metaLivePOAP = new MetaLivePOAP("MetaLivePOAP", "MLP", "Alice", "https://bafybeig7wwdixqpzaqoxvbagbfxjbzgljzdgwgnufekrwtjeb7cjjvu7n4.ipfs.dweb.link/");

        vm.stopPrank();
    }

    function testAirdrop() public {
        vm.startPrank(alice);
        metaLivePOAP.airdrop(alice, "Airdrop");
        console.log("totalSupply: ", metaLivePOAP.totalSupply());
        console.log("ownerOf 0: ", metaLivePOAP.ownerOf(0));
        console.log("tokenURI: ", metaLivePOAP.tokenURI(0));
        vm.stopPrank();
    }
}