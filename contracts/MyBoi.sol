// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC721, ERC721Burnable } from "./base/ERC721/extensions/ERC721Burnable.sol";
import { ERC721Permit } from "./base/ERC721/extensions/ERC721Permit.sol";
import { ERC721URIStorage } from "./base/ERC721/extensions/ERC721URIStorage.sol";
import { PrimarySaleRecipient } from "./internal/PrimarySaleRecipient.sol";
import { ReentrancyGuard } from "./internal/ReentrancyGuard.sol";
import { IERC721A } from "./interfaces/IERC721A.sol";
import { IMyBoi } from "./interfaces/IMyBoi.sol";

contract MyBoi is
    IMyBoi,
    ERC721,
    ERC721Burnable,
    ERC721Permit,
    ERC721URIStorage,
    Ownable,
    PrimarySaleRecipient,
    ReentrancyGuard
{
    uint256 public constant MAX_SUPLLY = 1000;
    uint256 private _idCounter;

    constructor(string memory name_, string memory symbol_, string memory baseUri_) ERC721(name_, symbol_) {
        address sender = _msgSender();
        _setBaseURI(baseUri_);
        _setupPrimarySaleRecipient(sender);
        _idCounter = 1;
    }

    function exists(uint256 tokenId_) external view returns (bool) {
        return _exists(tokenId_);
    }

    function totalMinted() external view returns (uint256) {
        return _idCounter;
    }

    function setBaseTokenURI(string calldata baseTokenURI_) external override onlyOwner {
        _setBaseURI(baseTokenURI_);
        emit NewBaseTokenURI(baseTokenURI_);
    }

    function setupPrimarySaleRecipient(address recipient_) external override onlyOwner {
        _setupPrimarySaleRecipient(recipient_);
    }

    function buy(uint256 quantity_) external payable override nonReentrant {
        if (_idCounter + quantity_ > MAX_SUPLLY) revert MyBoi__ExceedLimit();

        address sender = _msgSender();
        _safeMint(sender, quantity_);
    }

    // The following functions are overrides required by Solidity.

    function _transfer(address from_, address to_, uint256 tokenId_) internal override(ERC721, ERC721Permit) {
        super._transfer(from_, to_, tokenId_);
    }

    function _baseURI() internal view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return _baseUri;
    }

    function _domainNameAndVersion() internal pure override returns (string memory name, string memory version) {
        return ("MyBoi", "1");
    }
}
