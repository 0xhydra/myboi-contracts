// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { IERC721Burnable } from "./IERC721Burnable.sol";
import { ERC721 } from "../ERC721.sol";

/**
 * @title ERC721Burnable.
 *
 * @dev ERC721 token that can be irreversibly burned (destroyed).
 */
abstract contract ERC721Burnable is ERC721, IERC721Burnable {
    /**
     * @dev Burns `tokenId`. See {ERC721-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function burn(uint256 tokenId) public virtual override {
        _burn(tokenId);
    }
}
