import { ChakraProvider, Flex, Heading } from "@chakra-ui/react";
import { Image as ChakraImage } from '@chakra-ui/image';
import Head from 'next/head';

import {
  ConnectButton,
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

const { wallets } = getDefaultWallets({
  appName,
  chains,
});

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

const WalletLayout = ({ children }: WalletLayoutProps) => {
  return (
    <WagmiConfig client={wagmiClient}>
      <Head>
        <link
          href="https://fonts.googleapis.com/css2?family=Righteous&display=swap"
          rel="stylesheet"
        />
        <link
          href="https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap"
          rel="stylesheet"
        />
      </Head>
      <RainbowKitProvider
        appInfo={demoAppInfo}
        chains={chains}
        theme={darkTheme({
          borderRadius: "small",
        })}
      >
        <ChakraProvider>
          <Flex
            minH="100vh"
            padding="1vw"
            flexDirection="column"
            alignItems="stretch"
            justifyContent="space-between"
          >
            <Flex align="center">
              <ChakraImage src="logo.png" alt="Your Image" boxSize="50px" marginRight="1rem" />
              <Heading
                fontFamily="'Righteous', sans-serif"
                fontStyle="normal"
                fontWeight="400"
                fontSize="25.8683px"
                lineHeight="101%"
                letterSpacing="-0.022em"
                color="#FF44EC">Space Can</Heading>
            </Flex>
            <Flex flexGrow={1}>{children}</Flex>
            <Flex justifyContent="space-between" alignItems="center">
            </Flex>
          </Flex>
        </ChakraProvider>
      </RainbowKitProvider>
    </WagmiConfig>
  );
};

export default WalletLayout;
