// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {LoginCoin} from "../src/LoginCoin.sol";

contract LoginCoinTest is Test {
    address alice = address(111);
    LoginCoin loginCoin;

    function setUp() public {
        vm.prank(alice);

        loginCoin = new LoginCoin("LoginCoin", "LC");
    }

    // function testToday() public {

    //     console.log("today: ", loginCoin.today());
    //     vm.prank(alice);
    //     // loginCoin.claim();

    // }
}