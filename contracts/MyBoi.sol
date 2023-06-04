// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC721, ERC721Burnable } from "./base/ERC721/extensions/ERC721Burnable.sol";
import { ERC721Permit } from "./base/ERC721/extensions/ERC721Permit.sol";
import { ERC721URIStorage } from "./base/ERC721/extensions/ERC721URIStorage.sol";
import { PaymentToken } from "./internal/PaymentToken.sol";
import { PrimarySaleRecipient } from "./internal/PrimarySaleRecipient.sol";
import { ReentrancyGuard } from "./internal/ReentrancyGuard.sol";
import { IMyBoi } from "./interfaces/IMyBoi.sol";
import { SafeTransferLib } from "./lib/SafeTransfer.sol";

contract MyBoi is
    IMyBoi,
    ERC721,
    ERC721Burnable,
    ERC721Permit,
    ERC721URIStorage,
    Ownable,
    PaymentToken,
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

    function setPayment(address token_, uint256 amount_) external override onlyOwner {
        _setPayment(token_, amount_);
    }

    function buy(address paymentToken_, uint256 quantity_) external payable override nonReentrant {
        address sender = _msgSender();
        uint256 amount = _paymentAmount[paymentToken_];
        if (amount == 0) revert MyBoi__ZeroValue();

        uint256 tokenId = _idCounter;

        if (tokenId + quantity_ > MAX_SUPLLY) revert MyBoi__ExceedLimit();

        uint256 total = amount * quantity_;

        if (paymentToken_ == address(0)) {
            if (msg.value < total) revert MyBoi__InsufficientBalance();
            SafeTransferLib.safeTransferETH(_recipient, total);
        } else {
            SafeTransferLib.safeTransferFrom(paymentToken_, sender, _recipient, total);
        }

        _batchMint(sender, tokenId, quantity_);
    }

    function _batchMint(address account_, uint256 tokenId_, uint256 totalMint_) internal {
        for (uint256 i; i < totalMint_; ) {
            unchecked {
                _safeMint(account_, tokenId_);
                ++tokenId_;
                ++i;
            }
        }
        _idCounter = tokenId_;
    }

    // The following functions are overrides required by Solidity.

    function _transfer(address from_, address to_, uint256 tokenId_) internal override(ERC721, ERC721Permit) {
        super._transfer(from_, to_, tokenId_);
    }

    function _baseURI() internal view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return _baseUri;
    }

    function _domainNameAndVersion() internal pure override returns (string memory, string memory) {
        return ("MyBoi", "1");
    }
}
