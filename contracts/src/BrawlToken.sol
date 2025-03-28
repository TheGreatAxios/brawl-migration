// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

error InsufficientSupplyAvailable();
error InvalidInput();

contract BrawlToken is ERC20, ERC20Burnable, AccessControl, ERC20Permit {
    
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 public constant MAX_SUPPLY = 270000000 * 10**18;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
        ERC20Permit("BrawlToken")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        if (totalSupply() + amount > MAX_SUPPLY) revert InsufficientSupplyAvailable();
        _mint(to, amount);
    }

    function batchMint(address[] memory tos, uint256[] memory amounts)  public onlyRole(MINTER_ROLE) {
        if (tos.length != amounts.length) revert InvalidInput();
        uint256 len = tos.length;

        uint256 amountAdded = 0;

        for (uint256 i = 0; i < len; i++) {
            amountAdded += amounts[i];
            _mint(tos[i], amounts[i]);
        }

        if (totalSupply() + amountAdded > MAX_SUPPLY) revert InsufficientSupplyAvailable();
    }
}