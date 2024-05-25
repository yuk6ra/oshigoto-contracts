// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OshigotoToken} from "../src/OshigotoToken.sol";

contract OshigotoTest is Test {
    OshigotoToken dn;
    address alice = address(111);

    function setUp() public {
        vm.prank(alice);
        dn = new OshigotoToken("DN404", "DN", 1000, address(this));
    }

    function testMint() public {
        vm.prank(dn.owner());
        dn.mint(alice, 100);
        assertEq(dn.totalSupply(), 1100);
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
        dn.withdraw();
        assertEq(address(dn).balance, 0);
        assertEq(alice.balance, 1 ether);
    }
}