// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev The proposed interface of Standard Gluwacoin V2 that extend the existing functions of ERC-20. It is fully compatible to V1
 */
interface IGluwacoinEthlessV2 {
    enum SigDomain {
        /*0*/
        Nothing,
        /*1*/
        Burn,
        /*2*/
        Mint,
        /*3*/
        Transfer,
        /*4*/
        Reserve,
        /*5*/
        Permit
    }

    /**
     * @notice Ethless transfer to move `amount` tokens from the `sender`'s account to `recipient`
     * and moves `fee` tokens from the `sender`'s account to a relayer's address.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits two {Transfer} events.
     *
     * Requirements:
     *
     * @param recipient cannot be the zero address.
     * @param sender must have a balance of at least the sum of `amount` and `fee`.
     * @param nonce is only used once per `sender`.
     */
    function transfer(
        address sender,
        address recipient,
        uint256 amount,
        uint256 fee,
        uint256 nonce,
        bytes calldata sig
    ) external returns (bool);

    /**
     * @notice Execute a transfer using signature for authorization
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits two {Transfer} events.
     *
     * Requirements:
     *
     * @param from          sender's address (Authorizer)
     * @param to            recipient's address
     * @param value         Amount to be transferred
     * @param validAfter    The time after which this is valid (unix time)
     * @param validBefore   The time before which this is valid (unix time)
     * @param nonce         Unique nonce
     * @param v of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     * @param r of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     * @param s of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     */
    function transferWithAuthorization(
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool);

    /**
     * @notice Ethless approve to set `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * @param owner token owner's address
     * @param spender the address will spend token on the behalf of the token owner, it cannot be the zero address.
     * @param value amount to be transferred.
     * @param deadline must be a timestamp in the future.
     * @param v of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     * @param r of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     * @param s of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool);

    /**
     * @notice Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * @dev Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     *
     * Requirements:
     *
     * @param owner token owner's address used for the permit txn
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @notice Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {action}.
     *
     * @dev Every successful call to {actoion} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     *
     * Requirements:
     *
     * @param owner token owner's address used for the {action} txn
     * @param action the {action} value
     */
    function nonces(address owner, SigDomain action)
        external
        view
        returns (uint256);
}
