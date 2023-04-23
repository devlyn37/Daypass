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
import { ReactNode } from "react";
import {
  WagmiConfig,
  configureChains,
  createClient,
  goerli,
  mainnet,
} from "wagmi";
import { polygon, polygonMumbai } from "wagmi/chains";
import { publicProvider } from "wagmi/providers/public";

const projectId = (() => {
  switch (process.env.NEXT_PUBLIC_CHAIN!) {
    case "ethereum":
      return "14507bac-5aad-47ba-8b9a-66d745436246";
    case "polygon":
      return "d00b56eb-3a21-44d7-803a-b7cca690fe6a";
  }

  return "14507bac-5aad-47ba-8b9a-66d745436246";
})();

const { chains, provider, webSocketProvider } = configureChains(
  [
    ...((): any[] => {
      switch (process.env.NEXT_PUBLIC_CHAIN!) {
        case "ethereum":
          return process.env.NEXT_PUBLIC_TESTNET === "true"
            ? [goerli]
            : [mainnet];
        case "polygon":
          return process.env.NEXT_PUBLIC_TESTNET === "true"
            ? [polygonMumbai]
            : [polygon];
      }

      return process.env.NEXT_PUBLIC_TESTNET === "true" ? [goerli] : [mainnet];
    })(),
  ],
  [publicProvider()]
);

const appName = "Daypass";
const demoAppInfo = {
  appName,
};

const connectors = connectorsForWallets([
  {
    groupName: "Social Smart Accounts",
    wallets: [
      googleWallet({ options: { projectId } }),
      githubWallet({ options: { projectId } }),
      twitterWallet({ options: { projectId } }),
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
]);

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
  webSocketProvider,
});

type WalletLayoutProps = {
  children: ReactNode;
};

const WalletProvider = ({ children }: WalletLayoutProps) => {
  return (
    <WagmiConfig client={wagmiClient}>
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
