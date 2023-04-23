import {
  RainbowKitProvider,
  connectorsForWallets,
  darkTheme,
} from "@rainbow-me/rainbowkit";
import {
  metaMaskWallet,
  walletConnectWallet,
  rainbowWallet,
} from "@rainbow-me/rainbowkit/wallets";
import "@rainbow-me/rainbowkit/styles.css";
import {
  githubWallet,
  googleWallet,
  twitterWallet,
} from "@zerodevapp/wagmi/rainbowkit";
import { ReactNode, useMemo } from "react";
import { WagmiConfig, configureChains, createClient, useNetwork } from "wagmi";
import { polygonMumbai, goerli } from "wagmi/chains";
import { publicProvider } from "wagmi/providers/public";

const supported_chains = [goerli, polygonMumbai];
const goerliZeroDevProjectId = "14507bac-5aad-47ba-8b9a-66d745436246";
const chainToZeroDevProjectId = new Map<number, string>([
  [5, goerliZeroDevProjectId],
  [80001, "d00b56eb-3a21-44d7-803a-b7cca690fe6a"],
]);

const { chains, provider, webSocketProvider } = configureChains(
  supported_chains,
  [publicProvider()]
);

const appName = "Daypass";
const demoAppInfo = {
  appName,
};

const getWagmiClient = (zeroDevProjectId: string) =>
  createClient({
    autoConnect: true,
    connectors: connectorsForWallets([
      {
        groupName: "Social Smart Accounts",
        wallets: [
          googleWallet({ options: { projectId: zeroDevProjectId } }),
          githubWallet({ options: { projectId: zeroDevProjectId } }),
          twitterWallet({ options: { projectId: zeroDevProjectId } }),
        ],
      },
      {
        groupName: "Standard Wallets",
        wallets: [
          metaMaskWallet({ chains }),
          rainbowWallet({ chains }),
          walletConnectWallet({ chains }),
        ],
      },
    ]),
    provider,
    webSocketProvider,
  });
const defaultWagmiClient = getWagmiClient(goerliZeroDevProjectId);

const WalletProvider = ({ children }: { children: ReactNode }) => {
  const { chain } = useNetwork();
  const chainId = chain?.id || goerli.id;
  const id = chainToZeroDevProjectId.get(chainId) ?? goerliZeroDevProjectId;
  const wagmiClient = useMemo(() => getWagmiClient(id), [chain]);

  return (
    <WagmiConfig client={wagmiClient ?? defaultWagmiClient}>
      <RainbowKitProvider
        appInfo={demoAppInfo}
        chains={chains}
        theme={darkTheme({
          borderRadius: "small",
        })}
      >
        {children}
      </RainbowKitProvider>
    </WagmiConfig>
  );
};

export default WalletProvider;
