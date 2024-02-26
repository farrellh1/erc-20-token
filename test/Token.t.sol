// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token public token;
    uint256 private immutable _initialSupply = 1000000;
    address public sender = makeAddr("sender");
    address public receiver = makeAddr("receiver");

    function setUp() public {
        token = new Token(_initialSupply);
    }

    function test_Name() public {
        assertEq(token.name(), "Token");
    }

    function test_Symbol() public {
        assertEq(token.symbol(), "TKN");
    }

    function test_Decimal() public {
        assertEq(token.decimals(), 18);
    }

    function test_BalanceOf() public transferTokenToSender {
        assertEq(token.balanceOf(sender), 100);
    }

    function test_Transfer() public {
        token.transfer(sender, 100);
        assertEq(token.balanceOf(sender), 100);
    }

    function test_RevertWhenTransferWithInsufficientBalance() public {
        vm.prank(sender);
        vm.expectRevert();
        token.transfer(receiver, 100);
    }

    function test_TransferFromSenderToReceiver() public transferTokenToSender {
        vm.prank(sender);
        token.transfer(receiver, 50);

        assertEq(token.balanceOf(receiver), 50);
        assertEq(token.balanceOf(sender), 50);
    }

    function test_Approve() public transferTokenToSender {
        vm.prank(sender);
        token.approve(receiver, 50);
        assertEq(token.allowance(sender, receiver), 50);
    }

    function test_TransferFrom() public transferTokenToSender approveAllowanceToReceiver {
        vm.prank(receiver);
        token.transferFrom(sender, receiver, 50);
    
        assertEq(token.balanceOf(receiver), 50);
        assertEq(token.balanceOf(sender), 50);
    }

    function test_TotalSupply() public {
        assertEq(token.totalSupply(), _initialSupply);
    }

    modifier transferTokenToSender() {
        token.transfer(sender, 100);
        _;
    }

    modifier approveAllowanceToReceiver() {
        vm.prank(sender);
        token.approve(receiver, 50);
        _;
    }
}
