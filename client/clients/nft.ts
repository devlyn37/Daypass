import { Signer, ethers } from "ethers";

const NFTABI = require("../contracts/Daypass.sol/Daypass.json");

export const mintNFT = async (
  contractAddress: string,
  signer: Signer,
  recipient: string
) => {
  const contract = new ethers.Contract(contractAddress, NFTABI.abi, signer);

  // const tx = await contract.mint(1);

  const tx = await contract.mintTo(1, recipient);

  console.log(`minting NFT... hash=${tx.hash}`);

  const receipt = await tx.wait();

  console.log("minted a new NFT", receipt);
};
