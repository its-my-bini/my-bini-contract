#!/bin/bash

# Load environment variables if .env exists
if [ -f .env ]; then
  source .env
fi

# Check if PRIVATE_KEY is set
if [ -z "$PRIVATE_KEY" ]; then
  echo "Error: PRIVATE_KEY is not set. Please set it in .env or export it."
  echo "Example: export PRIVATE_KEY=0xYourPrivateKey"
  exit 1
fi

echo "Deploying MonadTreasury to Monad Testnet..."

# Run forge script
forge script script/Deploy.s.sol:DeployTreasury \
  --rpc-url https://testnet-rpc.monad.xyz \
  --broadcast \
  # --verify \
  # --verifier blockscout \
  # --verifier-url https://testnet.monadexplorer.com/api/ \
  # --etherscan-api-key 339CSQ23HAPKQAZS1MZBS74UEKZEIQ5I8R

if [ $? -eq 0 ]; then
  echo "✅ Deployment successful!"
else
  echo "❌ Deployment failed."
fi
