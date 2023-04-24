import { BigNumber, Signer, ethers } from "ethers";
const setupHelpersABI = require("../contracts/SetupHelper.sol/SetupHelper.json");

export type SetupDaypassRequest = {
  targets: string[];
  transferable: boolean;
  gasLimitPerOperation: BigNumber;
  spendingLimitPerOperation: number;
  timeLimitPerOperation: number;
  holders: string[];
};

export const setupDaypass = async (
  signer: Signer,
  contractAddress: string,
  entryPointAddress: string,
  req: SetupDaypassRequest
) => {
  const contract = new ethers.Contract(
    contractAddress,
    setupHelpersABI.abi,
    signer
  );

  const tx = await contract.setupDaypass(
    entryPointAddress,
    req.targets,
    req.transferable,
    req.gasLimitPerOperation,
    req.spendingLimitPerOperation,
    req.timeLimitPerOperation,
    req.holders,
    {
      // for now 2 ether because needs to stake 1 ether at least
      value: ethers.utils.parseEther("1"),
    }
  );

  console.log("tx hash", tx.hash);

  const receipt = await tx.wait();

  console.log("receipt", receipt);

  const setupEvent = (receipt.events ?? []).find(
    (e: any) => e.event === "DaypassSetUp"
  );

  if (!setupEvent) {
    throw new Error("Setup event was not returned");
  }

  const passNFT = setupEvent.args![0];
  const paymaster = setupEvent.args![1];

  console.log("setup", {
    passNFT,
    paymaster,
  });

  return {
    passNFT,
    paymaster,
  };
};
