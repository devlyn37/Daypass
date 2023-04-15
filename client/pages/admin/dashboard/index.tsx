import { Stack, Text } from "@chakra-ui/react";
import { useAccount } from "wagmi";
import AdminDashboardLayout from "./AdminDashboardLayout";

const AdminDashboardPage = () => {
  const { address } = useAccount();
  return (
    <AdminDashboardLayout>
      <Stack justify="flex-start" align="flex-start" spacing="9px">
        <Text
          fontFamily="PolySans Median"
          lineHeight="1.5"
          fontWeight="regular"
          fontSize="20px"
          letterSpacing="-0.02em"
          color="#000000"
        >
          Welcome to Day Pass
        </Text>
        <Text
          fontFamily="PolySans Median"
          lineHeight="1.01"
          fontWeight="regular"
          fontSize="58px"
          letterSpacing="-0.02em"
          color="#000000"
          width="742px"
          maxWidth="100%"
        >
          Onboard new users faster than ever.
        </Text>
        <Text
          fontFamily="PolySans Neutral"
          lineHeight="1.5"
          fontWeight="regular"
          fontSize="24px"
          letterSpacing="-0.02em"
          color="#000000"
          width="662px"
          maxWidth="100%"
        >
          Say goodbye to gas fees and hello to frictionless onboarding.
          Seamlessly mint and distribute NFTs to your users and provide them
          with a gasless transaction experience.
        </Text>
      </Stack>
    </AdminDashboardLayout>
  );
};

export default AdminDashboardPage;
