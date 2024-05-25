// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OshigotoToken} from "../src/OshigotoToken.sol";
import {LoginCoin} from "../src/LoginCoin.sol";

contract OshigotoTest is Test {
    OshigotoToken dn;
    address alice = address(111);

    LoginCoin loginCoin;

    function setUp() public {
        vm.prank(alice);
        dn = new OshigotoToken("DN404", "DN", 0, address(this));

        loginCoin = new LoginCoin("LoginCoin", "LC");
    }

    function testMint() public {

        vm.prank(dn.owner());
        dn.setPriceWithNativeToken(1);
        dn.mintWithNativeToken{value: 1}();

        assertEq(dn.totalSupply(), 1);
    }

    function testMintWithERC20Token() public {
        vm.startPrank(alice);

        loginCoin.mint(alice, 200);
        console.log("alice balance: ", loginCoin.balanceOf(alice));
        loginCoin.approve(address(dn), 100);

        dn.setPaymentTokenAddress(address(loginCoin));
        dn.setPriceWithERC20Token(100);

        dn.mintWithERC20Token();
        console.log("alice balance: ", loginCoin.balanceOf(alice));
        console.log("OshigotoToken balance: ", dn.balanceOf(alice));

        assertEq(dn.totalSupply(), 1);

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
}