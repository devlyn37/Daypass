import {
  Box,
  Button,
  Circle,
  Flex,
  FormControl,
  Heading,
  Input,
  InputGroup,
  InputRightElement,
  Radio,
  RadioGroup,
  Select,
  Stack,
  Switch,
  Text,
} from "@chakra-ui/react";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { useAccount } from "wagmi";
import AdminDashboardLayout from "./AdminDashboardLayout";

const AdminDashboardPage = () => {
  const router = useRouter();
  const { address } = useAccount();
  const [value, setValue] = useState("1");

  useEffect(() => {
    if (!address) {
      router.push("/admin/dashboard");
    }
  }, [address]);

  return (
    <AdminDashboardLayout>
      <Flex justifyContent="center">
        <Box>
          <FormControl>
            <Box
              borderRadius="20px"
              width="954px"
              maxWidth="100%"
              background="#FFFFFF"
              boxShadow="0px 4px 20px 0px rgba(0, 0, 0, 0.15)"
              p="6"
              rounded="md"
            >
              <Flex
                alignItems="center"
                justifyContent="space-between"
                borderBottom="1px solid #E2E8F0"
                mb="5"
                pb="5"
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
                    Create Paymaster
                  </Text>
                </Heading>
                <Flex
                  alignItems="center"
                  justifyContent="space-between"
                  minW="235px"
                >
                  <Circle size="28px" background="#0075FF">
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="14px"
                      letterSpacing="-0.02em"
                      color="#ffffff"
                    >
                      1
                    </Text>
                  </Circle>
                  <Text
                    fontFamily="PolySans Neutral"
                    lineHeight="1.5"
                    fontWeight="regular"
                    fontSize="14px"
                    letterSpacing="-0.02em"
                    color="#000000"
                  >
                    Define
                  </Text>

                  <Box w="72px" h="1px" bg="#E2E8F0"></Box>
                  <Text
                    fontFamily="PolySans Neutral"
                    lineHeight="1.5"
                    fontWeight="regular"
                    fontSize="14px"
                    letterSpacing="-0.02em"
                    color="#000000"
                  >
                    Send
                  </Text>
                  <Circle size="28px" background="#A0AEC0">
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="14px"
                      letterSpacing="-0.02em"
                      color="#ffffff"
                    >
                      2
                    </Text>
                  </Circle>
                </Flex>
              </Flex>
              <Flex justifyContent="space-between" mb="5">
                <Box>
                  <Heading variant="h2">
                    <Text
                      fontFamily="PolySans Median"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="18px"
                      letterSpacing="-0.02em"
                      color="#000000"
                      mb="2"
                    >
                      Contract Address
                    </Text>
                  </Heading>
                  <Input
                    placeholder="Paste your Contract Address"
                    size="lg"
                    width="548px"
                    height="48px"
                    maxWidth="100%"
                  />
                </Box>
                <Box w="320px" pl="5">
                  <Heading variant="h2">
                    <Text
                      fontFamily="PolySans Median"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="18px"
                      letterSpacing="-0.02em"
                      color="#000000"
                      mb="2"
                    >
                      Network
                    </Text>
                  </Heading>
                  <Select placeholder="Specify Network" size="lg" />
                </Box>
              </Flex>
              <Heading variant="h2">
                <Text
                  fontFamily="PolySans Median"
                  lineHeight="1.5"
                  fontWeight="regular"
                  fontSize="18px"
                  letterSpacing="-0.02em"
                  color="#000000"
                  mb="2"
                >
                  Restrictions
                </Text>
              </Heading>
              <Text
                fontFamily="PolySans Neutral"
                lineHeight="1.5"
                fontWeight="regular"
                fontSize="16px"
                letterSpacing="-0.02em"
                color="#000000"
                mb="4"
              >
                Specify the interaction restrictions for the NFTs.
              </Text>
              <Box
                borderRadius="12px"
                width="898px"
                maxWidth="100%"
                borderColor="gray.200"
                borderWidth="1px"
              >
                <Flex
                  alignItems="center"
                  justifyContent="space-between"
                  borderBottom="1px solid #E2E8F0"
                  px="7"
                  py="4"
                >
                  <Heading variant="h3" mb="1">
                    <Text
                      fontFamily="PolySans Median"
                      lineHeight="1.5"
                      fontSize="16px"
                    >
                      Type
                    </Text>
                  </Heading>
                  <Heading variant="h3" w="50%">
                    <Text
                      fontFamily="PolySans Median"
                      lineHeight="1.5"
                      fontSize="16px"
                    >
                      Action
                    </Text>
                  </Heading>
                </Flex>
                <Flex
                  alignItems="center"
                  justifyContent="space-between"
                  borderBottom="1px solid #E2E8F0"
                  px="7"
                  py="4"
                >
                  <Box>
                    <Heading variant="h3" mb="1">
                      <Text
                        fontFamily="PolySans Neutral"
                        lineHeight="1.5"
                        fontSize="16px"
                      >
                        Allow to transfer
                      </Text>
                    </Heading>
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      color="#A0AEC0"
                    >
                      Make Day Pass NFTs transferable or soulbound.
                    </Text>
                  </Box>
                  <Stack direction="row" justify="left" align="center" w="50%">
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      letterSpacing="-0.02em"
                      color="#000000"
                    >
                      Off
                    </Text>
                    <Switch />
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      letterSpacing="-0.02em"
                      color="#000000"
                    >
                      On
                    </Text>
                  </Stack>
                </Flex>

                <Flex
                  alignItems="center"
                  justifyContent="space-between"
                  borderBottom="1px solid #E2E8F0"
                  px="7"
                  py="4"
                >
                  <Box>
                    <Heading variant="h3" mb="1">
                      <Text
                        fontFamily="PolySans Neutral"
                        lineHeight="1.5"
                        fontSize="16px"
                      >
                        Allow to trade
                      </Text>
                    </Heading>
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      color="#A0AEC0"
                    >
                      Block or allow trading.
                    </Text>
                  </Box>
                  <Stack direction="row" justify="left" align="center" w="50%">
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      letterSpacing="-0.02em"
                      color="#000000"
                    >
                      Off
                    </Text>
                    <Switch />
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      letterSpacing="-0.02em"
                      color="#000000"
                    >
                      On
                    </Text>
                  </Stack>
                </Flex>

                <Flex
                  alignItems="center"
                  justifyContent="space-between"
                  borderBottom="1px solid #E2E8F0"
                  px="7"
                  py="4"
                >
                  <Box w="50%" pr="2">
                    <Heading variant="h3" mb="1">
                      <Text
                        fontFamily="PolySans Neutral"
                        lineHeight="1.5"
                        fontSize="16px"
                      >
                        Gas limit
                      </Text>
                    </Heading>
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      color="#A0AEC0"
                    >
                      Specify a maximum gas limit you want your users to spend.
                    </Text>
                  </Box>

                  <Stack direction="row" justify="left" align="center" w="50%">
                    <Box w="40%">
                      <Stack direction="row" justify="left" align="center">
                        <Text
                          fontFamily="PolySans Neutral"
                          lineHeight="1.5"
                          fontWeight="regular"
                          fontSize="16px"
                          letterSpacing="-0.02em"
                          color="#000000"
                        >
                          Off
                        </Text>
                        <Switch />
                        <Text
                          fontFamily="PolySans Neutral"
                          lineHeight="1.5"
                          fontWeight="regular"
                          fontSize="16px"
                          letterSpacing="-0.02em"
                          color="#000000"
                        >
                          On
                        </Text>
                      </Stack>
                    </Box>
                    <Box w="60%">
                      <InputGroup>
                        <Input type="gaslimit" placeholder="0" />
                        <InputRightElement
                          pointerEvents="none"
                          fontSize="16px"
                          children="Gwei"
                          pr="4"
                        />
                      </InputGroup>
                    </Box>
                  </Stack>
                </Flex>

                <Flex
                  alignItems="center"
                  justifyContent="space-between"
                  borderBottom="1px solid #E2E8F0"
                  px="7"
                  py="4"
                >
                  <Box w="50%" pr="2">
                    <Heading variant="h3" mb="1">
                      <Text
                        fontFamily="PolySans Neutral"
                        lineHeight="1.5"
                        fontSize="16px"
                      >
                        Spending limit
                      </Text>
                    </Heading>
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      color="#A0AEC0"
                    >
                      Specify a maximum spending limit for user per single
                      transaction.
                    </Text>
                  </Box>
                  <Stack direction="row" justify="left" align="center" w="50%">
                    <Box w="40%">
                      <Stack direction="row" justify="left" align="center">
                        <Text
                          fontFamily="PolySans Neutral"
                          lineHeight="1.5"
                          fontWeight="regular"
                          fontSize="16px"
                          letterSpacing="-0.02em"
                          color="#000000"
                        >
                          Off
                        </Text>
                        <Switch />
                        <Text
                          fontFamily="PolySans Neutral"
                          lineHeight="1.5"
                          fontWeight="regular"
                          fontSize="16px"
                          letterSpacing="-0.02em"
                          color="#000000"
                        >
                          On
                        </Text>
                      </Stack>
                    </Box>

                    <Box w="60%">
                      <InputGroup>
                        <Input type="spendinglimit" placeholder="0" />
                        <InputRightElement
                          pointerEvents="none"
                          fontSize="16px"
                          children="USD"
                          pr="4"
                        />
                      </InputGroup>
                    </Box>
                  </Stack>
                </Flex>

                <Flex
                  alignItems="center"
                  justifyContent="space-between"
                  px="7"
                  py="4"
                >
                  <Box w="50%" pr="2">
                    <Heading variant="h3" mb="1">
                      <Text
                        fontFamily="PolySans Neutral"
                        lineHeight="1.5"
                        fontSize="16px"
                      >
                        Time limit
                      </Text>
                    </Heading>
                    <Text
                      fontFamily="PolySans Neutral"
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="16px"
                      color="#A0AEC0"
                    >
                      Setup a timeframe after which NFT will expire.
                    </Text>
                  </Box>
                  <Stack direction="row" justify="left" align="center" w="50%">
                    <Box w="40%">
                      <Stack direction="row" justify="left" align="center">
                        <Text
                          fontFamily="PolySans Neutral"
                          lineHeight="1.5"
                          fontWeight="regular"
                          fontSize="16px"
                          letterSpacing="-0.02em"
                          color="#000000"
                        >
                          Off
                        </Text>
                        <Switch />
                        <Text
                          fontFamily="PolySans Neutral"
                          lineHeight="1.5"
                          fontWeight="regular"
                          fontSize="16px"
                          letterSpacing="-0.02em"
                          color="#000000"
                        >
                          On
                        </Text>
                      </Stack>
                    </Box>

                    <Box w="60%">
                      <RadioGroup
                        onChange={setValue}
                        value={value}
                        name="timeLimit"
                      >
                        <Stack direction="row">
                          <Radio value="1">
                            <Text
                              fontFamily="PolySans Neutral"
                              lineHeight="1.5"
                              fontWeight="regular"
                              fontSize="14px"
                              letterSpacing="-0.02em"
                              color="#000000"
                            >
                              Week
                            </Text>
                          </Radio>
                          <Radio value="2">
                            <Text
                              fontFamily="PolySans Neutral"
                              lineHeight="1.5"
                              fontWeight="regular"
                              fontSize="14px"
                              letterSpacing="-0.02em"
                              color="#000000"
                            >
                              Month
                            </Text>
                          </Radio>
                          <Radio value="3">
                            <Text
                              fontFamily="PolySans Neutral"
                              lineHeight="1.5"
                              fontWeight="regular"
                              fontSize="14px"
                              letterSpacing="-0.02em"
                              color="#000000"
                            >
                              3 months
                            </Text>
                          </Radio>
                        </Stack>
                      </RadioGroup>
                    </Box>
                  </Stack>
                </Flex>
              </Box>
            </Box>
            <Flex justify="flex-end" mt="8">
              <Button width="206px" height="40px">
                Next
              </Button>
            </Flex>
          </FormControl>
        </Box>
      </Flex>
    </AdminDashboardLayout>
  );
};

export default AdminDashboardPage;
