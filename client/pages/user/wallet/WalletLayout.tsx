import { ChakraProvider, Flex, Heading } from "@chakra-ui/react";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";

import { ReactNode } from "react";

type WalletLayoutProps = {
  children: ReactNode;
};

const WalletLayout = ({ children }: WalletLayoutProps) => {
  return (
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
      </Flex>
    </ChakraProvider>
  );
};

export default WalletLayout;
