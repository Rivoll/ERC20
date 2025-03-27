// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {MyERC20} from "../src/myERC20.sol";
import {DeployMyERC20} from "../script/DeployMyERC20.s.sol";

/*contract test a son addresse, et les fonctions de test sont appelées par cette adresse qui appele le
 contract DeployMyERC20. DeployMyERC20 appele MYERC20 et le déploie sur la blockchain.

*/

contract TestERC20 is Test {
    MyERC20 public token;
    address public owner;
    address public user1;
    address public user2;

    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    modifier onlyOwner() {
        token.mint(INITIAL_SUPPLY);
        _;
    }

    function setUp() public {
        token = new DeployMyERC20().run();
        owner = address(this);
        console.log("Owner is", owner);
        user1 = address(1);
        user2 = address(2);
    }

    function testMyERC20Init() public {
        assertEq(token.totalSupply(), 1000 ether);
        assertEq(token.balanceOf(owner), 0);
        token.mint(100 ether);
        assertEq(token.balanceOf(owner), 100 ether);
        token.transfer(address(0x1), 50 ether);
        assertEq(token.balanceOf(owner), 50 ether);
        assertEq(token.balanceOf(address(0x1)), 50 ether);
    }

    function testTransfer() public onlyOwner {
        // owner transfer 100 tokens to user1
        bool success = token.transfer(user1, 100 ether);
        assertTrue(success);
        assertEq(token.balanceOf(user1), 100 ether);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - 100 ether);
    }

    function testTransferFailIfInsufficient() public onlyOwner {
        vm.prank(user1);
        vm.expectRevert();
        token.transfer(user2, 100 ether);
    }

    function testApproveAndTransferFrom() public onlyOwner {
        // owner approve user1 to spend 100 tokens
        token.approve(user1, 100 ether);

        // user1 transfer 100 tokens from owner to user2
        vm.prank(user1);
        bool success = token.transferFrom(owner, user2, 100 ether);

        assertTrue(success);
        assertEq(token.balanceOf(user2), 100 ether);
        assertEq(token.allowance(owner, user1), 0);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - 100 ether);
    }

    function testTransferFromFailIfNoAllowance() public onlyOwner {
        vm.prank(user1);
        vm.expectRevert();
        token.transferFrom(owner, user2, 100 ether);
    }

    function testTransferFromFailIfInsufficientBalance() public onlyOwner {
        token.approve(user1, 100 ether);

        vm.prank(user1);
        vm.expectRevert();
        token.transferFrom(user1, user2, 50 ether);
    }

    function testIncreaseAllowance() public onlyOwner {
        bool success = token.increaseAllowance(user1, 200 ether);
        assertTrue(success);
        assertEq(token.allowance(owner, user1), 200 ether);
    }

    function testDecreaseAllowance() public onlyOwner {
        token.approve(user1, 150 ether);
        token.decreaseAllowance(user1, 50 ether);
        assertEq(token.allowance(owner, user1), 100 ether);
    }

    function testDecreaseAllowanceToZero() public onlyOwner {
        token.approve(user1, 20 ether);
        token.decreaseAllowance(user1, 100 ether); // Overkill
        assertEq(token.allowance(owner, user1), 0);
    }

    function testMintIncreasesBalance() public onlyOwner {
        uint256 before = token.balanceOf(user1);
        vm.prank(user1);
        token.mint(500 ether);
        assertEq(token.balanceOf(user1), before + 500 ether);
    }
}
