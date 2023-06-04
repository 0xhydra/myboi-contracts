// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IPrimarySaleRecipient {
    /// @dev The adress that receives all primary sales value.
    function primarySaleRecipient() external view returns (address);

    /// @dev Emitted when a new sale recipient is set.
    event PrimarySaleRecipientUpdated(address indexed recipient);
}
