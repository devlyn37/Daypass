import { Box, Button, Container, Flex, Heading, Text } from "@chakra-ui/react";
import Image from "next/image";
import { useRouter } from "next/router";
import { useEffect } from "react";
import { useAccount } from "wagmi";
import AdminDashboardLayout from "./AdminDashboardLayout";

const AdminDashboardPage = () => {
  const { address } = useAccount();
  const router = useRouter();

  return (
    <AdminDashboardLayout>
      <Container maxW="100%">
        <Box maxW="750px" pt="200px">
          <Flex alignItems="center" mb="3px">
            <Box w="52px" h="1px" bg="#000000" mr="2" />
            <Heading variant="h1" height="30px">
              <Text
                fontFamily="PolySans Median"
                lineHeight="1.5"
                fontWeight="regular"
                fontSize="20px"
                letterSpacing="-0.02em"
                color="#000000"
                textAlign="center"
              >
                Welcome to Day Pass
              </Text>
            </Heading>
          </Flex>
          <Heading variant="h2" mb="23px">
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
          </Heading>
          <Text
            fontFamily="PolySans Neutral"
            lineHeight="1.5"
            fontWeight="regular"
            fontSize="24px"
            letterSpacing="-0.02em"
            color="#000000"
            width="662px"
            maxWidth="100%"
            mb="40px"
          >
            Say goodbye to gas fees and hello to frictionless onboarding.
            Seamlessly mint and distribute NFTs to your users and provide them
            with a gasless transaction experience.
          </Text>
        </Box>
        <Image
          src="/images/DayPassTop.png"
          alt="DayPass Top"
          width={760}
          height={760}
          style={{ position: "fixed", top: "71px", left: "696px" }}
        />
        <Button
          onClick={() => {
            router.push("/admin/dashboard/contracts");
          }}
        >
          Get Started
        </Button>
      </Container>
    </AdminDashboardLayout>
  );
};

export default AdminDashboardPage;
