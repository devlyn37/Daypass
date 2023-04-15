import { useAccount } from "wagmi";
import WalletLayout from "./WalletLayout";

const WalletPage = () => {
  const { address } = useAccount();
  return <WalletLayout>{address && <div> connected! </div>}</WalletLayout>;
};

export default WalletPage;
