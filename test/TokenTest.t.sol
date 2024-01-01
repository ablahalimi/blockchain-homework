// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/token.sol";

contract TokenSimpleTest is Test {

    function testInitialState() public {
        TokenSimple token = new TokenSimple("MyToken", "MTK", 18, 1000000);

        assertEq(token.title(), "MyToken");
        assertEq(token.emblem(), "MTK");
        assertEq(token.points(), 18);
        assertEq(token.totalAmount(), 1000000);
        assertEq(token.quantityOfTokens(msg.sender), 1000000);
    }

    function testSend() public {
        TokenSimple token = new TokenSimple("MyToken", "MTK", 18, 1000000);
        address recipient = address(0x1234567890123456789012345678901234567890);

        token.send(recipient, 1000);

        assertEq(token.quantityOfTokens(msg.sender), 999000);
        assertEq(token.quantityOfTokens(recipient), 1000);
        assertEq(token.totalAmount(), 1000000);
        assertEq(token.quantityOfTokens(msg.sender), 999000); // Check the balance after transfer
    }

    function testSendFailsWithInsufficientBalance() public {
        TokenSimple token = new TokenSimple("MyToken", "MTK", 18, 1000000);
        address recipient = address(0x1234567890123456789012345678901234567890);

        bool sendResult = token.send(recipient, 1000001);

        assertEq(sendResult, false); // Check that the transfer fails
        assertEq(token.quantityOfTokens(msg.sender), 1000000); // Check that the balance remains unchanged
    }

    function testAuthorizeAndSendFrom() public {
        TokenSimple token = new TokenSimple("MyToken", "MTK", 18, 1000000);
        address spender = address(0xAbcDEF01234567890ABCDef0124567890AbcdeF0);

        token.authorize(spender, 500);
        token.sendFrom(msg.sender, address(this), 400);

        assertEq(token.quantityOfTokens(msg.sender), 996000);
        assertEq(token.quantityOfTokens(address(this)), 400);
        assertEq(token.grantPermission(msg.sender, spender), 100);
    }

    function testEliminate() public {
        TokenSimple token = new TokenSimple("MyToken", "MTK", 18, 1000000);

        token.eliminate(500);

        assertEq(token.quantityOfTokens(msg.sender), 999500);
    }

    function testCashOut() public {
        TokenSimple token = new TokenSimple("MyToken", "MTK", 18, 1000000);

        token.cashOut(500);

        assertEq(token.quantityOfTokens(msg.sender), 999500);
    }

    function testIngress() public {
        TokenSimple token = new TokenSimple("MyToken", "MTK", 18, 1000000);

        token.ingress(500);

        assertEq(token.quantityOfTokens(msg.sender), 1000500);
    }
}
