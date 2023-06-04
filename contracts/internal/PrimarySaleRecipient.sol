// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import { IPrimarySaleRecipient } from "../interfaces/IPrimarySaleRecipient.sol";

abstract contract PrimarySaleRecipient is IPrimarySaleRecipient {
    /// @dev The address that receives all primary sales value.
    address internal _recipient;

    /// @dev Returns primary sale recipient address.
    function primarySaleRecipient() external view override returns (address) {
        return _recipient;
    }

    /// @dev Lets a contract owner set the recipient for all primary sales.
    function _setupPrimarySaleRecipient(address recipient_) internal {
        _recipient = recipient_;
        emit PrimarySaleRecipientUpdated(recipient_);
    }
}
