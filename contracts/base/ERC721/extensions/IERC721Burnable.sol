// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @dev Interface of ERC721ABurnable.
 */
interface IERC721Burnable {
    /**
     * @dev Burns `tokenId`. See {ERC721A-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function burn(uint256 tokenId) external;
}
