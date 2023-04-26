import { Box, Button, Flex, Heading, Text, Textarea } from "@chakra-ui/react";
import { useEffect, useState } from "react";
import { useAccount, useSigner } from "wagmi";
import AdminDashboardLayout from "./AdminDashboardLayout";
import { ethers } from "ethers";
import { airdropNFTs } from "../clients/nft";
import { LOCALSTORAGE_KEY_DAY_PASS_ADDRESS } from "../consts/localstorage";

const DEFAULT_NFT_CONTRACT_ADDRESS =
  "0x2faf65bB673540061048259c06C4E1a9988F80e0";

const AirdropPage = () => {
  const { address } = useAccount();
  const [airdropAddresses, setAirdropAddresses] = useState("");
  const handleChange = (event: any) => setAirdropAddresses(event.target.value);
  const [submiting, setSubmiting] = useState(false);

  const [nftContractAddress, setNftContractAddress] = useState("");

  useEffect(() => {
    setNftContractAddress(
      localStorage.getItem(LOCALSTORAGE_KEY_DAY_PASS_ADDRESS) ??
        DEFAULT_NFT_CONTRACT_ADDRESS
    );
  }, []);

  const { data: signer } = useSigner();

  const airdropDaypasses = async (addresses: string[]) => {
    const hasBadAddress = addresses
      .map(ethers.utils.isAddress)
      .some((result) => result === false);

    if (hasBadAddress) {
      console.error("not address: " + address);
      return;
    }

    if (!signer) {
      console.error("signer is not ready");
      return;
    }

    try {
      await airdropNFTs(nftContractAddress!, signer, addresses);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <AdminDashboardLayout>
      <Flex justifyContent="center">
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
              lineHeight="1.5"
              fontWeight="regular"
              fontSize="24px"
              letterSpacing="-0.02em"
              color="#000000"
            >
              Send Daypasses
            </Text>
          </Heading>
          <Textarea
            mt="24px"
            value={airdropAddresses}
            onChange={handleChange}
            placeholder="recipient addresses (comma separated)"
            disabled={submiting}
            height="200px"
          />
          <Button
            isDisabled={!address}
            isLoading={submiting}
            colorScheme="blue"
            mt="16px"
            onClick={async () => {
              setSubmiting(true);
              const addresses = airdropAddresses
                .split(",")
                .map((addr) => addr.trim());
              await airdropDaypasses(addresses);
              setAirdropAddresses("");
              setSubmiting(false);
            }}
          >
            Send Daypasses
          </Button>
        </Box>
      </Flex>
    </AdminDashboardLayout>
  );
};

export default AirdropPage;
