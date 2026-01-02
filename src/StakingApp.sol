// SPDX-License-Identifier: MIT
pragma solidity  0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract StakingApp is Ownable{
    // 1. StakingToken address
    // 2. Admin

    // variables
    address public stakingToken;
    address public admin;

    constructor(address stakingToken_, address owner_) Ownable(owner_) {
        stakingToken = stakingToken_;
    }

}