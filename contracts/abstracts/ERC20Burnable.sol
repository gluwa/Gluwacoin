// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../interfaces/IGluwacoinEthlessV1.sol";

import "./Validate.sol";

/**
 * @dev Extension of {ERC20} that allows users to burn an amount of token to reduce total token supply or to retrieve collaterized asset
 *
 */
abstract contract ERC20Burnable is
    Initializable,
    ERC20Upgradeable,
    IGluwacoinEthlessV1
{
    event Burnt(address indexed burnFrom, uint256 _value);

    /**
     * @notice Destroys `amount` tokens from the caller, transferring base tokens from the contract to the caller.
     *
     * See {ERC20-_burn}.
     *
     * Emits one {Transfer} event and one {Burnt} event
     *
     */
    function burn(uint256 amount) external virtual returns (bool success);

    /**
     * @notice `burn` but with `burner`, `fee`, `nonce`, and `sig` as extra parameters.
     * `fee` is a burn fee amount in Gluwacoin, which the burner will pay for the burn.
     * `sig` is a signature created by signing the burn information with the burner’s private key.
     * Anyone can initiate the burn for the burner by calling the Etherless Burn function
     * with the burn information and the signature.
     * The caller will have to pay the gas for calling the function.
     *
     * Destroys `amount` + `fee` tokens from the burner.
     * Transfers `amount` of base tokens from the contract to the burner and `fee` of base token to the caller.
     *
     * See {ERC20-_burn}.
     *
     * Emits two {Transfer} events and one {Burnt} event
     *
     *
     * Requirements:
     *
     * - the burner must have tokens of at least `amount`, the `fee` is included in the amount.
     */
    function burn(
        address burner,
        uint256 amount,
        uint256 fee,
        uint256 nonce,
        bytes calldata sig
    ) external virtual returns (bool success);
}
