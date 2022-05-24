// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../IGluwacoinV1.sol";

import "../utils/Validate.sol";

/**
 * @dev Extension of {ERC20} that allows users to mint a token based on certain condition or collaterized asset
 *
 */
abstract contract ERC20Mintable is
    Initializable,
    ERC20Upgradeable,
    IGluwacoinV1
{
    event Mint(address indexed mintTo, uint256 value);

    /**
     * @notice Creates `amount` tokens to the caller, based on certain condition or collaterized asset.
     *
     * See {ERC20-_mint} and {ERC20-allowance} to send an accepted collaterized asset to the contract to mint the token
     *
     * Emits one {Transfer} event and one {Mint} event
     *
     * Requirements:
     *
     * - the caller must have base tokens of at least `amount`.
     * - the contract must have allowance for caller's base tokens of at least `amount` (when minting based on a collaterized asset)
     */
    function mint(uint256 amount) external virtual returns (bool success);

    /**
     * @notice Ethless `mint` with `minter`, `fee`, `nonce`, and `sig` as extra parameters.
     * `fee` is a mint fee amount in the minted token, which the minter will pay for the mint.
     * `sig` is a signature created by signing the mint information with the minter’s private key.
     * Anyone can initiate the mint for the minter by calling the Etherless Mint function
     * with the mint information and the signature.
     * The caller will have to pay the gas for calling the function.
     *
     * Transfers `amount` + `fee` of base tokens from the minter to the contract using `transferFrom`.
     * Creates `amount` + `fee` of tokens to the minter and transfers `fee` tokens to the caller.
     *
     * See {ERC20-_mint} and {ERC20-allowance} to send an accepted collaterized asset to the contract to mint the token
     *
     * Emits two {Transfer} events and one {Mint} event
     *
     * Requirements:
     *
     * - the minter must have base tokens of at least `amount`.
     * - the contract must have allowance for receiver's base tokens of at least `amount` collaterized asset
     * - `fee` will be deducted after successfully minting
     */
    function mint(
        address minter,
        uint256 amount,
        uint256 fee,
        uint256 nonce,
        bytes calldata sig
    ) external virtual returns (bool success);
}
