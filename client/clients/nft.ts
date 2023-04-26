import { Signer, ethers } from "ethers";

const NFTABI = require("../contracts/Daypass.sol/Daypass.json");

export const airdropNFTs = async (
  contractAddress: string,
  signer: Signer,
  recipients: string[]
) => {
  const contract = new ethers.Contract(contractAddress, NFTABI.abi, signer);
  const tx = await contract.batchMint(recipients);
  console.log(`airdropping daypasses to ${recipients.length} hash: ${tx.hash}`);
  const receipt = await tx.wait();
  console.log("Done", receipt);
};
