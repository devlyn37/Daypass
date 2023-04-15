import { Card, Image } from "@chakra-ui/react";
import { useAccount } from "wagmi";
import WalletLayout from "./WalletLayout";
import useNFTs from "./useNFTs";

const WalletPage = () => {
  const { address } = useAccount();

  const NFT_CONTRACT_ADDRESS = "0xf03C1cB42c64628DE52d8828D534bFa2c6Fd65Df";
  const nfts = useNFTs(NFT_CONTRACT_ADDRESS, address as string);

  if (!address) {
    return (
      <WalletLayout>
        <></>
      </WalletLayout>
    );
  }

  return (
    <WalletLayout>
      <div>
        {nfts.map((nft) => (
          <Card p="4" m="4" key={nft.tokenId}>
            <div>Token ID: {nft.tokenId}</div>
            <div>Name: {nft.name}</div>
            <Image
              src={nft.image}
              alt={nft.name}
              borderRadius="lg"
              border="1px"
            />
          </Card>
        ))}
      </div>
    </WalletLayout>
  );
};

export default WalletPage;
