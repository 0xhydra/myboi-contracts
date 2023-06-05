// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IMyBoi {
    error MyBoi__ExceedLimit();
    error MyBoi__ZeroValue();
    error MyBoi__InsufficientBalance();

    event BatchMint(address recipient, uint256 tokenId, uint256 quantity);

    function setBaseTokenURI(string calldata baseTokenURI_) external;

    function setupPrimarySaleRecipient(address recipient_) external;

    function setPayment(address token_, uint256 amount_) external;

    function buy(address paymentToken, uint256 quantity_) external payable;
}
