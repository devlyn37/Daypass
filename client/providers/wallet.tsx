import {
  RainbowKitProvider,
  connectorsForWallets,
  darkTheme,
  getDefaultWallets,
} from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";
import {
  metaMaskWallet,
  walletConnectWallet,
} from "@rainbow-me/rainbowkit/wallets";
import {
  discordWallet,
  enhanceWalletWithAAConnector,
  facebookWallet,
  githubWallet,
  googleWallet,
  twitchWallet,
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
import { publicProvider } from "wagmi/providers/public";

const projectId = "14507bac-5aad-47ba-8b9a-66d745436246";

const { chains, provider, webSocketProvider } = configureChains(
  [...(process.env.NEXT_PUBLIC_TESTNET === "true" ? [goerli] : [mainnet])],
  [publicProvider()]
);

const connectors = connectorsForWallets([
  {
    groupName: "Social",
    wallets: [
      googleWallet({ options: { projectId } }),
      facebookWallet({ options: { projectId } }),
      githubWallet({ options: { projectId } }),
      discordWallet({ options: { projectId } }),
      twitchWallet({ options: { projectId } }),
      twitterWallet({ options: { projectId } }),
    ],
  },
  {
    groupName: "Web3 Wallets (AA-enabled)",
    wallets: [
      enhanceWalletWithAAConnector(metaMaskWallet({ chains }), { projectId }),
      enhanceWalletWithAAConnector(walletConnectWallet({ chains }), {
        projectId,
      }),
    ],
  },
]);

const appName = "EVM Hackathon Starter";

// const { chain } = getDefaultWallets({
//   appName,
//   chains,
// });

const demoAppInfo = {
  appName,
};

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
