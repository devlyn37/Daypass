import { ReactNode } from "react";

type AdminDashboardLayoutProps = {
  children: ReactNode;
};

import { ChakraProvider, Flex, extendTheme } from "@chakra-ui/react";
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
        <ChakraProvider>
          <Flex
            marginTop="30px"
            marginLeft="70px"
            marginRight="70px"
            flexDirection="column"
            alignItems="stretch"
            justifyContent="space-between"
          >
            <Flex
              justifyContent="space-between"
              alignItems="center"
              marginBottom="40px"
            >
              <DayPassLogo />
              <ConnectButton />
            </Flex>
            {children}
          </Flex>
        </ChakraProvider>
      </RainbowKitProvider>
    </WagmiConfig>
  );
};

export default AdminDashboardLayout;
