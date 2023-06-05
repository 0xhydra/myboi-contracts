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

/**
 * @title MyBoi Collection
 * .----------------.  .----------------.  .----------------.  .----------------.  .----------------.
 * | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
 * | | ____    ____ | || |  ____  ____  | || |   ______     | || |     ____     | || |     _____    | |
 * | ||_   \  /   _|| || | |_  _||_  _| | || |  |_   _ \    | || |   .'    `.   | || |    |_   _|   | |
 * | |  |   \/   |  | || |   \ \  / /   | || |    | |_) |   | || |  /  .--.  \  | || |      | |     | |
 * | |  | |\  /| |  | || |    \ \/ /    | || |    |  __'.   | || |  | |    | |  | || |      | |     | |
 * | | _| |_\/_| |_ | || |    _|  |_    | || |   _| |__) |  | || |  \  `--'  /  | || |     _| |_    | |
 * | ||_____||_____|| || |   |______|   | || |  |_______/   | || |   `.____.'   | || |    |_____|   | |
 * | |              | || |              | || |              | || |              | || |              | |
 * | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 * '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
 * @author 0xHydra (👀,💎)
 */

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

    /**
     * @dev Initializes the MyBoi NFT.
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     * @param baseUri_ The base URI for token metadata.
     * @param paymentToken_ The address of the payment token.
     * @param amount_ The amount of payment token required for each purchase.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseUri_,
        address paymentToken_,
        uint256 amount_
    ) ERC721(name_, symbol_) {
        address sender = _msgSender();
        _setBaseURI(baseUri_);
        _setupPrimarySaleRecipient(sender);
        _setPayment(paymentToken_, amount_);
        _idCounter = 1;
    }

    /**
     * @dev Checks if a given token ID exists.
     * @param tokenId_ The ID of the token to check.
     * @return A boolean indicating whether the token exists.
     */
    function exists(uint256 tokenId_) external view returns (bool) {
        return _exists(tokenId_);
    }

    /**
     * @dev Returns the total number of tokens minted.
     * @return The total number of tokens minted.
     */
    function totalMinted() external view returns (uint256) {
        return _idCounter - 1;
    }

    /**
     * @dev Sets the base token URI for token metadata.
     * @param baseTokenURI_ The new base token URI.
     */
    function setBaseTokenURI(string calldata baseTokenURI_) external override onlyOwner {
        _setBaseURI(baseTokenURI_);
    }

    /**
     * @dev Sets the primary sale recipient address.
     * @param recipient_ The address of the primary sale recipient.
     */
    function setupPrimarySaleRecipient(address recipient_) external override onlyOwner {
        _setupPrimarySaleRecipient(recipient_);
    }

    /**
     * @dev Sets the payment token and amount required for each purchase.
     * @param token_ The address of the payment token.
     * @param amount_ The amount of payment token required for each purchase.
     */
    function setPayment(address token_, uint256 amount_) external override onlyOwner {
        _setPayment(token_, amount_);
    }

    /**
     * @dev Allows the sender to purchase tokens by providing payment tokens.
     * @param paymentToken_ The address of the payment token.
     * @param quantity_ The quantity of tokens to purchase.
     */
    function buy(address paymentToken_, uint256 quantity_) external payable override nonReentrant {
        address sender = _msgSender();
        uint256 amount = _paymentAmount[paymentToken_];
        uint256 tokenId = _idCounter;

        unchecked {
            if (tokenId + quantity_ - 1 > MAX_SUPLLY) revert MyBoi__ExceedLimit();
        }

        uint256 total = amount * quantity_;

        if (total == 0) revert MyBoi__ZeroValue();

        if (paymentToken_ == address(0)) {
            if (msg.value < total) revert MyBoi__InsufficientBalance();
            SafeTransferLib.safeTransferETH(_recipient, total);
        } else {
            SafeTransferLib.safeTransferFrom(paymentToken_, sender, _recipient, total);
        }

        emit BatchMint(sender, tokenId, quantity_);
        _batchMint(sender, tokenId, quantity_);
    }

    /**
     * @dev Internal function for batch minting tokens.
     * @param account_ The recipient of the minted tokens.
     * @param tokenId_ The starting token ID.
     * @param totalMint_ The total number of tokens to mint.
     */
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

    /**
     * @dev Transfers the ownership of a token from one address to another.
     * @param from_ The current owner of the token.
     * @param to_ The new owner of the token.
     * @param tokenId_ The ID of the token to transfer.
     */
    function _transfer(address from_, address to_, uint256 tokenId_) internal override(ERC721, ERC721Permit) {
        super._transfer(from_, to_, tokenId_);
    }

    /**
     * @dev Returns the base URI for token metadata.
     * @return The base URI for token metadata.
     */
    function _baseURI() internal view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return _baseUri;
    }

    /**
     * @dev Returns the name and version of the ERC712.
     * @return The name and version of the contract.
     */
    function _domainNameAndVersion() internal pure override returns (string memory, string memory) {
        return ("MyBoi", "1");
    }
}
