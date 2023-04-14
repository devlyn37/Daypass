# Contracts

Hackathon contract env

## Setup

1. Install Rust: https://www.rust-lang.org/tools/install
2. Install Foundry: https://github.com/foundry-rs/foundry (read some more about this as well)
3. run ```forge test``` to confirm things are working

## Deploying a Contract

You'll need a wallet and some ETH (or whatever currency depending on chain) for this, if you don't have that set up [here](https://www.coindesk.com/learn/how-to-set-up-a-metamask-wallet/) is a good place to start.
You can find an RPC url on our [alchemy page](https://www.alchemy.com/)

**Make sure to grab a RPC url that corresponds to the chain you want to deploy to**

Load the env

```
source .env
```

Deploy and verify the contract

```
forge create --rpc-url $GOERLI_RPC_URL \
    --constructor-args "Arg1" 2 3 \
    --private-key $PRIVATE_KEY \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --verify \
    src/Hackathon721.sol:Hackathon721
```

## Testing Contracts

Read here for more information: https://book.getfoundry.sh/forge/tests

to run the tests with trace

```forge test -vvvv```