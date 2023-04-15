import { Box, Button, Heading, Input, Text } from "@chakra-ui/react";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { useAccount, useSigner } from "wagmi";
import AdminDashboardLayout from "./AdminDashboardLayout";
import { ethers } from "ethers";
import { mintNFT } from "../../../clients/nft";
import { LOCALSTORAGE_KEY_DAY_PASS_ADDRESS } from "../../../consts/localstorage";

// const NFT_CONTRACT_ADDRESS = "0x5a89d913b098c30fcb34f60382dce707177e171e";
// const NFT_CONTRACT_ADDRESS="0xf03C1cB42c64628DE52d8828D534bFa2c6Fd65Df";
const DEFAULT_NFT_CONTRACT_ADDRESS="0xf03C1cB42c64628DE52d8828D534bFa2c6Fd65Df";
// const DaypassAddress = "0xa1F209805fBc1eb69BDeE37D7Ce629e80b31B722";

const AirdropPage = () => {
  const router = useRouter();
  const { address } = useAccount();
  const [airdropAddress, setAirdropAddress] = useState("");
  const handleChange = (event: any) => setAirdropAddress(event.target.value);
  const [submiting, setSubmiting] = useState(false);

  const [nftContractAddress, setNftContractAddress] = useState('');

  useEffect(() => {
    setNftContractAddress(localStorage.getItem(LOCALSTORAGE_KEY_DAY_PASS_ADDRESS) ?? DEFAULT_NFT_CONTRACT_ADDRESS)
  }, []);

  useEffect(() => {
    if (!address) {
      router.push("/admin/dashboard");
    }
  }, [address]);

  const { data: signer } = useSigner();

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
          placeholder="Input recipient address"
          size="sm"
        />
        <Button
          isLoading={submiting}
          colorScheme="blue"
          mt="16px"
          onClick={() => {
            if (!ethers.utils.isAddress(airdropAddress)) {
              console.error("not address: " + airdropAddress);
              return;
            }

            if (!signer) {
              console.error("signer is not ready");
              return;
            }

            (async () => {
              setSubmiting(true);
              try {
                await mintNFT(
                  nftContractAddress!,
                  signer,
                  airdropAddress
                );
                setAirdropAddress('');
              } catch (error) {
                console.error(error);
              } finally {
                setSubmiting(false);
              }
            })();
          }}
        >
          Send Daypass
        </Button>
      </Box>
    </AdminDashboardLayout>
  );
};

export default AirdropPage;
