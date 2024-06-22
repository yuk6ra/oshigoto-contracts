// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OshigotoToken} from "../src/OshigotoToken.sol";
import {LoginCoin} from "../src/LoginCoin.sol";
import {DN404Mirror} from "../src/dn404/DN404Mirror.sol";

contract OshigotoTest is Test {
    OshigotoToken dn;
    address alice = address(111);

    LoginCoin loginCoin;
    DN404Mirror public nft;

    uint96 initialTokenSupply = 1*10**18;

    function setUp() public {

        vm.prank(alice);
        dn = new OshigotoToken("DN404", "DN", "Alice", initialTokenSupply, address(this));

        nft = DN404Mirror(payable(address(dn.mirrorERC721())));

        loginCoin = new LoginCoin("LoginCoin", "LC");
    }

    function testMint() public {

        vm.prank(dn.owner());
        dn.setPriceWithNativeToken(0.01 ether);
        // dn.mintWithNativeToken{value: 0.01 ether}();

        // assertEq(dn.totalSupply(), initialTokenSupply + 1);
    }

    function testMintWithERC20Token() public {
        vm.startPrank(alice);

        loginCoin.mint(alice, 200);
        loginCoin.approve(address(dn), 200);

        dn.setPaymentTokenAddress(address(loginCoin));
        dn.setPriceWithERC20Token(50);

        console.log(nft.totalSupply());
        dn.mintWithERC20Token(alice);
        dn.mintWithERC20Token(alice);
        dn.mintWithERC20Token(alice);
        console.log(nft.totalSupply());
        // console.log("alice balance: ", loginCoin.balanceOf(alice));
        console.log("OshigotoToken balance: ", dn.balanceOf(alice));
        // assertEq(dn.totalSupply(), initialTokenSupply + 1);

        dn.rankOf(1);
        console.log("Hi");
        console.log("rankOf: ", dn.rankOf(1));
        console.log("tokenURI: ", nft.tokenURI(1));

        vm.stopPrank();
    }

    function testName() public view {
        assertEq(dn.name(), "DN404");
    }

    function testSymbol() public view {
        assertEq(dn.symbol(), "DN");
    }

    function testWithdraw() public {
        vm.deal(address(dn), 1 ether);
        assertEq(address(dn).balance, 1 ether);
        vm.prank(alice);
        dn.withdrawWithNativeToken();
        assertEq(address(dn).balance, 0);
        assertEq(alice.balance, 1 ether);
    }

    // function testMint2() public {
    //     vm.prank(alice);
    //     dn.setMintAmount(1*10**18);

    //     dn.mintWithNativeToken{value: 1 ether}();

    //     vm.prank(alice);
    //     dn.setDataURI("https://example.com/");


    //     console.log("address of DN404Mirror: ", address(dn.mirrorERC721()));
    //     console.log("OshigotoToken balance: ", dn.balanceOf(alice));
    //     console.log("OshigotoToken totalSupply: ", dn.totalSupply());

    //     // Read DN404Mirror contract
    //     DN404Mirror mirror = DN404Mirror(payable(address(dn.mirrorERC721())));
    //     console.log("name: ", mirror.name());
    //     console.log("totalSupply: ", mirror.totalSupply());
    //     console.log("tokenURI: ", mirror.tokenURI(0));
    // }
}