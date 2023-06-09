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
    src/Simple721.sol:Simple721
```

To deploy the paymaster with the script

```
forge script script/DaypassPaymaster.s.sol:MyScript --rpc-url $GOERLI_RPC_URL --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify -vvvv
```

## Testing Contracts

Read here for more information: https://book.getfoundry.sh/forge/tests

to run the tests with trace

```forge test -vvvv```

## Deployments of SetupHelper contract

### Ethereum Goerli

0xac74de54Ae45Eb8dB7F34545C96CBcab59Be3a47

https://goerli.etherscan.io/address/0xac74de54Ae45Eb8dB7F34545C96CBcab59Be3a47

### Polygon Mumbai

0x1782a694bdb712237aed7b14d3ce93f12b0cffeb

https://mumbai.polygonscan.com/address/0x1782a694bdb712237aed7b14d3ce93f12b0cffeb

### Mantle Testnet

0x841b7a8ed11564e94815e069ba64084bf798c06b

https://explorer.testnet.mantle.xyz/address/0x841b7A8ED11564E94815E069bA64084bF798C06b

### Scroll Testnet

0x841b7a8ed11564e94815e069ba64084bf798c06b

https://blockscout.scroll.io/address/0x841b7A8ED11564E94815E069bA64084bF798C06b

### Celo Alfajores Testnet

0xd8a2e11a8c3776f1f74ea898f54ba86af25c1864

https://explorer.celo.org/alfajores/address/0xD8A2E11a8C3776f1F74Ea898f54bA86Af25c1864

## GNOSIS mainnet

0xe13f6c3d9f95e1d0cb26050d587fba18d1f57958

https://gnosisscan.io/address/0xe13f6c3d9f95e1d0cb26050d587fba18d1f57958