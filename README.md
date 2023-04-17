# What is Daypass?

Send an NFT and automatically cover the recipients gas! Daypass allows the distribution and organization of gas sponsorship via NFTs or "Daypasses". We abstract paymaster deployment complexity, and leverage the composability of NFTs for AA based gas sponsorship.

Here's an example of a daypass NFT: [Example Daypass NFT on OpenSea Testnet](https://testnets.opensea.io/assets/goerli/0x9be69e0c05ec9e9deb4ea16de4fc8e08a500f198/1)

## How to use the Demo

Things are a little rough around the edges right now, and very much optimized for the happy path XD. Here are the steps:

1. Visit [daypass.dev](https://daypass.dev), connect with a standard EAO account, then hit **Get Started**.

2. Fill out the form (all of these may or may not apply XD) and hit **Next**, this will do four things:
    - Deploy a Daypass NFT contract
    - Deploy a Paymaster Contract
    - Stake and deposit 0.5 eth for the paymaster
    - Transfer ownership of both the NFT contract and paymaster contract to the caller (you!)

3. After that's complete, you'll be redirected to the **Airdrop page** where you send these Daypass NFTs to different users. But here's where it gets a bit confusing, you won't know which address to send the NFT to yet!

4. In a new tab, open [daypass.dev/user/mint](https://daypass.dev/user/mint)
    - Disconnect your wallet from only this page (yuck I know)
    - Hit **Connect** again and this time choose a social wallet.
    - Once that's connected, grab the address from the top right corner.
    - Sometimes this doesn't work do to some upstream issues with ZeroDev :(, You can still check the contracts that are deployed

    Here's proof that it works:
    https://www.jiffyscan.xyz/userOpHash/0x88a848130614fae589f4210f82189ab00ccfa06cd0f6b413c719bfd5b739834f?network=goerli

5. Send this address an NFT from the airdrop page.

6. On the mint page you just connected your social wallet to, hit the mint button!
    - You're gonna see the paymaster address appear in the input, that's a little hackathon local storage magic for the purposes of the demo

7. Voila, you just created a smart account via socials, then minted an NFT, all while paying zero gas because you hold a daypass!

## Deployments

### Ethereum Goerli
https://goerli.etherscan.io/address/0xac74de54Ae45Eb8dB7F34545C96CBcab59Be3a47

### Polygon Mumbai
https://mumbai.polygonscan.com/address/0x1782a694bdb712237aed7b14d3ce93f12b0cffeb

### Mantle Testnet
https://explorer.testnet.mantle.xyz/address/0x841b7A8ED11564E94815E069bA64084bF798C06b

### Scroll Testnet
https://blockscout.scroll.io/address/0x841b7A8ED11564E94815E069bA64084bF798C06b

### Celo Alfajores Testnet
https://explorer.celo.org/alfajores/address/0xD8A2E11a8C3776f1F74Ea898f54bA86Af25c1864

## GNOSIS mainnet
https://gnosisscan.io/address/0xe13f6c3d9f95e1d0cb26050d587fba18d1f57958
