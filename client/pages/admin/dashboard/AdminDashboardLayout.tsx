import { ReactNode } from "react";

type AdminDashboardLayoutProps = {
  children: ReactNode;
};

import { ChakraProvider, Flex, extendTheme } from "@chakra-ui/react";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";
import DayPassLogo from "../../../components/DayPassLogo";

const theme = extendTheme({
  fonts: {
    heading: "PolySans Median",
    body: "PolySans Neutral",
  },
});

const AdminDashboardLayout = ({ children }: AdminDashboardLayoutProps) => {
  return (
    <ChakraProvider theme={theme}>
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
  );
};

export default AdminDashboardLayout;
