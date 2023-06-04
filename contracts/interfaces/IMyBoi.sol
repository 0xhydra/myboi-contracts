// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IMyBoi {
    error MyBoi__ExceedLimit();

    function setBaseTokenURI(string calldata baseTokenURI_) external;

    function setupPrimarySaleRecipient(address recipient_) external;

    function buy(uint256 quantity_) external payable;
}
