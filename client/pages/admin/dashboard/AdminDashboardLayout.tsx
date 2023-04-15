import { ReactNode } from "react";

type AdminDashboardLayoutProps = {
  children: ReactNode;
};

import { Box, ChakraProvider, Flex, Heading, Text, extendTheme } from "@chakra-ui/react";
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
import DayPassLogo from "../../../components/DayPassLogo";

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

const theme = extendTheme({
  fonts: {
    heading: "PolySans Median",
    body: "PolySans Neutral",
  },
});

const AdminDashboardLayout = ({ children }: AdminDashboardLayoutProps) => {
  return (
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider
        appInfo={demoAppInfo}
        chains={chains}
        theme={darkTheme({
          borderRadius: "small",
        })}
      >
        <ChakraProvider theme={theme}>
          <Box px={12}>
            <Box as="header">
              <Flex
                as="header"
                w="100%"
                py={4}
                mb={6}
                alignItems="center"
                justifyContent="space-between"
              >
                <DayPassLogo />
                <ConnectButton />
              </Flex>
            </Box>
            <Box as="main">{children}</Box>
          </Box>
        </ChakraProvider>
      </RainbowKitProvider>
    </WagmiConfig>
  );
};

export default AdminDashboardLayout;
