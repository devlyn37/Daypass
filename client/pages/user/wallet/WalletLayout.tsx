import {
  Box,
  ChakraProvider,
  Flex,
  Heading,
  Image as ChakraImage,
} from "@chakra-ui/react";
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
        flexDirection="column"
        alignItems="stretch"
        justifyContent="space-between"
        style={{
          backgroundImage: `url('/background.png')`,
          backgroundSize: "cover",
        }}
      >
        <Flex
          justifyContent="space-between"
          alignItems="center"
          style={{ padding: "20px 20px 20px 20px" }}
        >
          <Flex>
            <Box justifyContent="center" alignItems="center">
              <ChakraImage
                src="/logo.png"
                alt="Logo"
                width="60px"
                paddingRight="10px"
              />
            </Box>
            <Heading color="#FF44EC">Space Can</Heading>
          </Flex>
          <ConnectButton />
        </Flex>
        <Flex flexGrow={1}>{children}</Flex>
      </Flex>
    </ChakraProvider>
  );
};

export default WalletLayout;
