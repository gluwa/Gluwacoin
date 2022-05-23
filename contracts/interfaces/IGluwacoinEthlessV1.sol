// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IGluwacoinEthlessV1 {

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
}
