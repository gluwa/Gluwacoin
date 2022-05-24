// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "./ERC20Mintable.sol";

/**
 * @dev Extension of {ERC20} that allows users to to get an amount of token based on certain condition submitted by a minter.
 * The minter is a DAO contract
 *
 */
abstract contract ERC20MintableSidechain is ERC20Mintable {
    address public minter;

    event MinterUpdated(address indexed oldMinter, address indexed newMinter);

    function __ERC20Mintable_init(address minter_) internal onlyInitializing {
        __ERC20Mintable_init_unchained(minter_);
    }

    function __ERC20Mintable_init_unchained(address minter_)
        internal
        onlyInitializing
    {
        updateMinter(minter_);
    }

    /**
     * @dev Throws if called by any account other than the minter
     */
    modifier onlyMinter() {
        require(
            msg.sender == minter,
            "ERC20MintableSidechain: caller is not the masterMinter"
        );
        _;
    }

    /**
     * @notice Creates `amount` tokens to the an account, submitted by the minter
     *
     * Emits one {Transfer} event and one {Mint} event
     *
     * @param account The address to get the minted token
     * @param amount the amount of token to be minted
     */
    function mint(address account, uint256 amount)
        external
        virtual
        onlyMinter
        returns (bool)
    {
        _mint(account, amount);
        emit Mint(account, amount);
        return true;
    }

    /**
     * @notice Function to replace current minter by a new minter. It is used when we want to use a new DAO contract
     * @param newMinter The address of the minter to remove
     * @return True if the operation was successful.
     */
    function updateMinter(address newMinter)
        public
        virtual
        onlyMinter
        returns (bool)
    {
        require(
            AddressUpgradeable.isContract(newMinter),
            "ERC20MintableSidechain: Minter must be a contract address"
        );
        address oldMinter = minter;
        minter = newMinter;
        emit MinterUpdated(oldMinter, newMinter);
        return true;
    }
}
