# ⛓ My Bini Contract

MonadTreasury smart contract for the My Bini autonomous AI companion agent. Handles native MON token deposits with user tracking, owner withdrawals, and balance queries. Deployed on Monad blockchain.

## Contract Overview

- **Contract Name:** MonadTreasury
- **Deployed Address:** `0x26f942e7c1D1F45c575649ed386C2fef68C06a8c`
- **Network:** Monad Mainnet
- **Solidity Version:** ^0.8.20
- **Framework:** Foundry (Forge)

The MonadTreasury contract is the on-chain component of My Bini. It acts as a treasury that:
- Accepts MON deposits from users with a userId parameter for backend indexing
- Emits `Deposit` events that the backend listens to for crediting in-app tokens
- Allows the contract owner to withdraw accumulated funds
- Provides balance query functionality

## Contract Interface

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MonadTreasury {
    address public owner;

    event Deposit(address indexed sender, string indexed userId, uint256 amount);
    event Withdrawal(address indexed owner, uint256 amount);

    modifier onlyOwner();

    constructor();

    function deposit(string memory userId) external payable;
    function withdraw() external; // onlyOwner
    function getBalance() external view returns (uint256);
}
```

## Functions

| Function | Access | Description |
|---|---|---|
| `deposit(userId)` | Public (payable) | Accepts MON payment, emits Deposit event with sender address, userId, and amount |
| `withdraw()` | Owner only | Withdraws all accumulated MON to the owner address |
| `getBalance()` | Public (view) | Returns the current contract balance |

## Events

| Event | Parameters | Description |
|---|---|---|
| `Deposit` | sender (indexed), userId (indexed), amount | Emitted when a user deposits MON |
| `Withdrawal` | owner (indexed), amount | Emitted when the owner withdraws funds |

## Token Economics

- Exchange Rate: 1 MON = 100 in-app tokens
- Users deposit MON to the treasury contract
- Backend verifies the transaction on-chain via Monad RPC using Viem
- Validates: recipient address matches treasury, amount matches claim, prevents double-processing
- Credits user's in-app token balance after verification

## Tech Stack

| Technology | Purpose |
|---|---|
| Solidity ^0.8.20 | Smart contract language |
| Foundry (Forge) | Development, testing & deployment |
| Monad | Target blockchain (EVM-compatible, high performance) |

## Prerequisites

- Foundry installed (`curl -L https://foundry.paradigm.xyz | bash` then `foundryup`)
- Monad RPC URL
- Private key for deployment

## Setup Instructions

```bash
# 1. Clone the repository
git clone https://github.com/its-my-bini/my-bini-contract.git
cd my-bini-contract

# 2. Install dependencies
forge install

# 3. Build contracts
forge build

# 4. Run tests
forge test

# 5. Deploy to Monad
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url https://testnet-rpc.monad.xyz \
  --private-key $PRIVATE_KEY \
  --broadcast

# Or using environment variables
source .env
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url $MONAD_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

## Environment Variables

```env
MONAD_RPC_URL=https://testnet-rpc.monad.xyz
PRIVATE_KEY=your-private-key
ETHERSCAN_API_KEY=your-etherscan-api-key  # optional, for verification
```

## Verification

```bash
forge verify-contract \
  0x26f942e7c1D1F45c575649ed386C2fef68C06a8c \
  src/MonadTreasury.sol:MonadTreasury \
  --chain monad \
  --rpc-url $MONAD_RPC_URL
```

## Integration with Backend

- The backend uses Viem to interact with the contract
- On deposit: user sends MON tx → backend receives tx hash → verifies on-chain → credits tokens
- Token service validates: recipient matches treasury address, amount matches claim, tx not already processed
- Real-time balance updates via Socket.io after successful deposit

## Related Repositories

- [my-bini-backend](https://github.com/its-my-bini/my-bini-backend) — AI agent backend server
- [my-bini-frontend](https://github.com/its-my-bini/my-bini-frontend) — Web application UI
- [.github](https://github.com/its-my-bini/.github) — Organization profile & docs

## License

MIT
