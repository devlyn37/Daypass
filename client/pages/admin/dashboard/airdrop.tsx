import { Box, Button, Heading, Input, Text } from "@chakra-ui/react";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { useAccount } from "wagmi";
import AdminDashboardLayout from "./AdminDashboardLayout";
import nftArtifact from "../../../contracts/Hackathon721.sol/Hackathon721.json";

const NFT_CONTRACT_ADDRESS = "0x5a89d913b098c30fcb34f60382dce707177e171e";

const AirdropPage = () => {
  const router = useRouter();
  const { address } = useAccount();
  const [airdropAddress, setAirdropAddress] = useState("");
  const handleChange = (event: any) => setAirdropAddress(event.target.value);

  useEffect(() => {
    if (!address) {
      router.push("/admin/dashboard");
    }
  }, [address]);

  return (
    <AdminDashboardLayout>
      <Box
        borderRadius="20px"
        width="954px"
        maxWidth="100%"
        background="#FFFFFF"
        boxShadow="0px 4px 20px 0px rgba(0, 0, 0, 0.15)"
        p="6"
        rounded="md"
        justifySelf={"center"}
      >
        <Heading variant="h1">
          <Text
            fontFamily="PolySans Median"
            lineHeight="1.5"
            fontWeight="regular"
            fontSize="24px"
            letterSpacing="-0.02em"
            color="#000000"
          >
            Send Daypass
          </Text>
        </Heading>

        <Text mb="8px" mt="8px">
          Address
        </Text>
        <Input
          value={airdropAddress}
          onChange={handleChange}
          placeholder="Here is a sample placeholder"
          size="sm"
        />
        <Button
          colorScheme="blue"
          mt="16px"
          onClick={() => {
            console.log(
              `Clicked the button, the address value is ${airdropAddress}`
            );
          }}
        >
          Send Daypass
        </Button>
      </Box>
    </AdminDashboardLayout>
  );
};

export default AirdropPage;
