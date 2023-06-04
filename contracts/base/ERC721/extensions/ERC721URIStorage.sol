// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { IERC721URIStorage } from "./IERC721URIStorage.sol";
import { ERC721 } from "../ERC721.sol";

/**
 * @dev ERC721 token with storage based token URI management.
 */
abstract contract ERC721URIStorage is IERC721URIStorage, ERC721 {
    string internal _baseUri;

    function baseURI() external view override returns (string memory) {
        return _baseURI();
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseUri;
    }

    function _setBaseURI(string memory baseUri_) internal virtual {
        _baseUri = baseUri_;
    }
}
