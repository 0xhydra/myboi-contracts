// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC721A, ERC721ABurnable } from "./base/ERC721/extensions/ERC721ABurnable.sol";

contract MyBoi is ERC721A, ERC721ABurnable, Ownable {
    constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}

    function exists(uint256 tokenId) external view returns (bool) {
        return _exists(tokenId);
    }

    function safeMint(address to, uint256 quantity) external onlyOwner {
        _safeMint(to, quantity);
    }
}
