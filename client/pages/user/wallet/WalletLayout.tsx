import { ReactNode } from "react";

type WalletLayoutProps = {
  children: ReactNode;
};

import { ChakraProvider, Flex, Heading, Text } from "@chakra-ui/react";
import {
  ConnectButton,
  RainbowKitProvider,
  connectorsForWallets,
  darkTheme,
  getDefaultWallets,
} from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";
import {
  WagmiConfig,
  configureChains,
  createClient,
  goerli,
  mainnet,
} from "wagmi";
import { publicProvider } from "wagmi/providers/public";

const appName = "EVM Hackathon Starter";

const { chains, provider, webSocketProvider } = configureChains(
  [...(process.env.NEXT_PUBLIC_TESTNET === "true" ? [goerli] : [mainnet])],
  [publicProvider()]
);

const { wallets } = getDefaultWallets({
  appName,
  chains,
});

const demoAppInfo = {
  appName,
};

const connectors = connectorsForWallets(wallets);

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
  webSocketProvider,
});

const WalletLayout = ({ children }: WalletLayoutProps) => {
  return (
    <WagmiConfig client={wagmiClient}>
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
            margin={10}
            flexDirection="column"
            alignItems="stretch"
            justifyContent="space-between"
          >
            <Flex justifyContent="space-between" alignItems="center">
              <Heading>Hackathon</Heading>
              <ConnectButton />
            </Flex>
            <Flex flexGrow={1}>{children}</Flex>
            <Flex justifyContent="space-between" alignItems="center">
              <Heading>Hackathon</Heading>
              <Text>Hi</Text>
              <Text>Hi</Text>
            </Flex>
          </Flex>
        </ChakraProvider>
      </RainbowKitProvider>
    </WagmiConfig>
  );
};

export default WalletLayout;
