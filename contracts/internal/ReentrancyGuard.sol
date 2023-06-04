// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

abstract contract ReentrancyGuard {
    error ReentrancyGuard__Locked();
    uint256 private locked = 1;

    modifier nonReentrant() virtual {
        if (locked > 1) revert ReentrancyGuard__Locked();

        locked = 2;

        _;

        locked = 1;
    }
}
