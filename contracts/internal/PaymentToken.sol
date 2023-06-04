// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import { IPaymentToken } from "../interfaces/IPaymentToken.sol";

abstract contract PaymentToken is IPaymentToken {
    mapping(address => uint256) internal _paymentAmount;

    function paymentAmount(address paymentToken_) external view returns (uint256) {
        return _paymentAmount[paymentToken_];
    }

    function _setPayment(address token_, uint256 amount_) internal {
        _paymentAmount[token_] = amount_;
        emit PaymentUpdated(token_, amount_);
    }
}
