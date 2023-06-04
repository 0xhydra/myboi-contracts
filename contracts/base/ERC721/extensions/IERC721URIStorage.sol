// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @dev Interface of IERC721URIStorage.
 */
interface IERC721URIStorage {
    event NewBaseTokenURI(string baseTokenURI);

    function baseURI() external view returns (string memory);
}
