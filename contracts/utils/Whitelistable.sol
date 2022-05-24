// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";


/**
 * @dev A utility to allow specific group of users perform a specific action.
 * It is useful for the case users need to pass AML/KYC process to purchase/trade token
*/
abstract contract Whitelistable is AccessControlEnumerableUpgradeable {
    mapping(address => bool) private _whitelisted;

    bytes32 public constant WHITELISTER_ROLE = keccak256("WHITELISTER");

    event Whitelisted(address indexed account);
    event UnWhitelisted(address indexed account);
    event WhitelisterAdded(address indexed newWhitelister);
    event WhitelisterRemoved(address indexed newWhitelister);

    /**
     * @dev Throws if called by any account other than the whitelister
     */
    modifier onlyWhitelister() {
        require(
            hasRole(WHITELISTER_ROLE, msg.sender),
            "Whitelistable: caller is not the whitelister"
        );
        _;
    }

    /**
     * @dev Throws if argument account is whitelisted
     * @param _account The address to check
     */
    modifier notWhitelisted(address _account) {
        require(
            !_whitelisted[_account],
            "Whitelistable: account is whitelisted"
        );
        _;
    }

    /**
     * @notice Checks if account is whitelisted
     *
     * @param _account The address to check
     */
    function isWhitelisted(address _account) external view returns (bool) {
        return _whitelisted[_account];
    }

    /**
     * @dev Whitelist an account
     *
     * Emits a {Whitelisted} events.
     *
     * @param account The address to be whitelisted
     */
    function whitelist(address account) virtual external;

    /**
     * @notice Removes account from whitelist
     *
     * Emits a {UnWhitelisted} events.
     *
     * @param account The address to remove from the whitelist
     */
    function unWhitelist(address account) virtual external;

    /**
     * @notice Adds whitelisting right to an account
     *
     * Emits a {WhitelisterAdded} event.
     *
     * @param newWhitelister The address to have the whitelist right
     */
    function addWhitelister(address newWhitelister) virtual external;

    /**
     * @notice Removes whitelisting right from an account
     *
     * Emits a {WhitelisterRemoved} event.
     *
     * @param existingWhitelister The address to remove from the whitelist
     */
    function removeWhitelister(address existingWhitelister) virtual external;
}
