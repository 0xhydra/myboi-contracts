// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IPaymentToken {
    function paymentAmount(address paymentToken_) external view returns (uint256);

    event PaymentUpdated(address token_, uint256 amount_);
}
