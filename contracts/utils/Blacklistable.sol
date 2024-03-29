// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";

/**
 * @dev A utility to prevent specific group of users performing a specific action.
 * It is useful for the case when there are violations/malicious activities made by the account
 */
abstract contract Blacklistable is AccessControlEnumerableUpgradeable {
    mapping(address => bool) private _blacklisted;

    bytes32 public constant BLACKLISTER_ROLE = keccak256("BLACKLISTER");

    event Blacklisted(address indexed account);
    event UnBlacklisted(address indexed account);
    event BlacklisterAdded(address indexed newBlacklister);
    event BlacklisterRemoved(address indexed newBlacklister);

    /**
     * @dev Throws if called by any account other than the blacklister
     */
    modifier onlyBlacklister() {
        require(
            hasRole(BLACKLISTER_ROLE, msg.sender),
            "Blacklistable: caller is not the blacklister"
        );
        _;
    }

    /**
     * @dev Throws if argument account is blacklisted
     * @param _account The address to check
     */
    modifier notBlacklisted(address _account) {
        require(
            !_blacklisted[_account],
            "Blacklistable: account is blacklisted"
        );
        _;
    }

    /**
     * @notice Checks if account is blacklisted
     *
     * @param _account The address to check
     */
    function isBlacklisted(address _account) external view returns (bool) {
        return _blacklisted[_account];
    }

    /**
     * @dev Blacklist an account
     *
     * Emits a {Blacklisted} events.
     *
     * @param account The address to be blacklisted
     */
    function blacklist(address account) external virtual;

    /**
     * @notice Removes account from blacklist
     *
     * Emits a {UnBlacklisted} events.
     *
     * @param account The address to remove from the blacklist
     */
    function unBlacklist(address account) external virtual;

    /**
     * @notice Adds blacklisting right to an account
     *
     * Emits a {BlacklisterAdded} event.
     *
     * @param newBlacklister The address to have the blacklist right
     */
    function addBlacklister(address newBlacklister) external virtual;

    /**
     * @notice Removes blacklisting right from an account
     *
     * Emits a {BlacklisterRemoved} event.
     *
     * @param existingBlacklister The address to remove from the blacklist
     */
    function removeBlacklister(address existingBlacklister) external virtual;
}
