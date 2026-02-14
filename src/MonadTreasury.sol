// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MonadTreasury
 * @dev Simple treasury contract to collect native MON payments and emit events for backend tracking.
 */
contract MonadTreasury {
    address public owner;

    event Deposit(address indexed sender, string indexed userId, uint256 amount);
    event Withdrawal(address indexed owner, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not authorized");
    }

    /**
     * @dev Deposit native MON into the treasury.
     * @param userId The UUID of the user in the backend system.
     */
    function deposit(string memory userId) external payable {
        require(msg.value > 0, "Amount must be greater than 0");
        emit Deposit(msg.sender, userId, msg.value);
    }

    /**
     * @dev Withdraw all collected funds to the owner's wallet.
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        (bool sent, ) = payable(owner).call{value: balance}("");
        require(sent, "Failed to send Ether");
        
        emit Withdrawal(owner, balance);
    }

    /**
     * @dev Check the contract's balance.
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
