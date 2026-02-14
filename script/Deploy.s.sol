// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MonadTreasury} from "../src/MonadTreasury.sol";

contract DeployTreasury is Script {
    function run() external returns (MonadTreasury) {
        // Retrieve private key from environment
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        MonadTreasury treasury = new MonadTreasury();

        vm.stopBroadcast();

        console.log("MonadTreasury deployed to:", address(treasury));
        return treasury;
    }
}
