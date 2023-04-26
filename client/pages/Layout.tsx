import { ReactNode } from "react";

import { ChakraProvider, Flex } from "@chakra-ui/react";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";
import DayPassLogo from "../components/DayPassLogo";
import Link from "next/link";

const Layout = ({ children }: { children: ReactNode }) => {
  return (
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
          <Link href="/">
            <DayPassLogo />
          </Link>

          <ConnectButton />
        </Flex>
        {children}
      </Flex>
    </ChakraProvider>
  );
};

export default Layout;
