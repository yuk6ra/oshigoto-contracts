// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OshigotoToken} from "../src/OshigotoToken.sol";
import {CheckCoin} from "../src/CheckCoin.sol";
import {DN404Mirror} from "../src/dn404/DN404Mirror.sol";
import {OshigotoGoodsExchange} from "../src/OshigotoGoodsExchange.sol";

contract OshigotoGoodsExchangeTest is Test {
    OshigotoToken public oshigotoToken; // DN404
    address alice = address(1289931);

    OshigotoGoodsExchange public oshigotoGoodsExchange;

    uint96 initialTokenSupply = 1*10**18;

    function setUp() public {

        vm.startPrank(alice);
        oshigotoToken = new OshigotoToken("DN404", "DN", "Alice", initialTokenSupply, address(this));
        oshigotoGoodsExchange = new OshigotoGoodsExchange(
            "AliceGoodsExchange",
            "AGE",
            "Alice",
            "https://bafybeig7wwdixqpzaqoxvbagbfxjbzgljzdgwgnufekrwtjeb7cjjvu7n4.ipfs.dweb.link/",
            address(oshigotoToken)
        );
        vm.stopPrank();
    }

    function testPurchaseGoodsA() public {
        uint256 nftMint = 6;
        for (uint i = 1; i <= nftMint*2; i++) {
            oshigotoToken.mintWithNativeToken{value: 0.0001 ether}(alice);
        }


        vm.startPrank(alice);
        oshigotoToken.approve(address(oshigotoGoodsExchange), 1 ether);
        oshigotoGoodsExchange.purchaseGoodsA(alice);
        console.log("totalSupply: ", oshigotoToken.totalSupply());
        console.log("ownerOf 0: ", oshigotoGoodsExchange.ownerOf(0));
        console.log("tokenURI: ", oshigotoGoodsExchange.tokenURI(0));

        vm.stopPrank();
    }

}