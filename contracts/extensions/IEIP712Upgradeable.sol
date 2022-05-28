// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP712.
 */
interface IEIP712Upgradeable {
    /**
     * @notice Returns the domain data which is used by EIP712 signature
     */
    function domainSeparator() external view returns (bytes32);

    /**
     * @notice Returns the contract version which is used by EIP712 signature
     */
    function version() external view returns (string memory);

    /**
     * @notice Returns the current chainid of the network.
     */
    function chainId() external view returns (uint256);

    /**
     * @notice Returns a boolean value indicating whether the recovered address == signer.
     *
     * Requirements:
     *
     * @param signer the address which is used to sign the signature
     * @param structHash has of the struct defined by the funciton signature and all parameters
     * @param v of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     * @param r of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     * @param s of a valid `secp256k1` signature from `owner` over the EIP712-formatted function arguments
     */
    function verify(
        address signer,
        bytes32 structHash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external view returns (bool);
}
