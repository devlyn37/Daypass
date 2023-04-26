import axios from "axios";
import { ethers } from "ethers";
import { useEffect, useState } from "react";
import { useProvider } from "wagmi";
import abi from "./../../../contracts/Daypass.sol/Daypass.json";

interface NFT {
  tokenId: string;
  name: string;
  image: string;
  tokenURI: string;
}

export default function useNFTs(
  contractAddress: string,
  walletAddress: string
): NFT[] {
  const [nfts, setNFTs] = useState<NFT[]>([]);
  const provider = useProvider();

  useEffect(() => {
    const fetchNFTs = async () => {
      const contract = new ethers.Contract(contractAddress, abi.abi, provider);

      const balance = await contract.balanceOf(walletAddress);

      const tokenIds = [];
      for (let i = 0; i < balance; i++) {
        const tokenId = await contract.tokenOfOwnerByIndex(walletAddress, i);
        tokenIds.push(tokenId.toString());
      }

      const nftPromises = tokenIds.map(async (tokenId) => {
        const tokenURI = await contract.tokenURI(tokenId);

        const metadata = await axios.get(tokenURI);
        const { name, image } = metadata.data;
        return {
          tokenId,
          tokenURI,
          name,
          image,
        };
      });

      const nftData = await Promise.all(nftPromises);
      setNFTs(nftData);
    };

    fetchNFTs();
  }, [contractAddress, walletAddress]);

  return nfts;
}
