// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {console} from "../lib/forge-std/src/Test.sol";
import {MyERC20} from "../src/myERC20.sol";

contract DeployMyERC20 is Script {
    function run() external returns (MyERC20) {
        console.log("address(this) is", address(this));
        vm.startBroadcast();
        MyERC20 coin = new MyERC20();
        vm.stopBroadcast();
        return (coin);
    }
}
