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
  const handleChange = (event: React.ChangeEvent<HTMLTextAreaElement>) =>
    setAirdropAddresses(event.target.value);
  const [submiting, setSubmiting] = useState(false);

  const [nftContractAddress, setNftContractAddress] = useState("");
  const [error, setError] = useState("");

  useEffect(() => {
    setNftContractAddress(
      localStorage.getItem(LOCALSTORAGE_KEY_DAY_PASS_ADDRESS) ??
        DEFAULT_NFT_CONTRACT_ADDRESS
    );
  }, []);

  const { data: signer } = useSigner();

  const airdropDaypasses = async () => {
    const addresses = airdropAddresses.split(",").map((addr) => addr.trim());
    const hasBadAddress = addresses
      .map(ethers.utils.isAddress)
      .some((result) => result === false);

    if (hasBadAddress) {
      setError("One or more addresses are invalid.");
      return;
    }

    if (!signer) {
      setError("Signer is not ready.");
      return;
    }

    setError("");
    setSubmiting(true);

    try {
      await airdropNFTs(nftContractAddress, signer, addresses);
      setError("");
    } catch (error) {
      setError("Something went wrong during the airdrop.");
    } finally {
      setAirdropAddresses("");
      setSubmiting(false);
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
            isDisabled={!address || airdropAddresses.trim() === ""}
            isLoading={submiting}
            colorScheme="blue"
            mt="16px"
            onClick={airdropDaypasses}
          >
            Send Daypasses
          </Button>
          <Text color="red.500" mt="2">
            {error}
          </Text>
        </Box>
      </Flex>
    </AdminDashboardLayout>
  );
};

export default AirdropPage;
