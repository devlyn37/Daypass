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
import { useForm } from "react-hook-form";
import { useAccount, useNetwork, useSigner } from "wagmi";
import AdminDashboardLayout from "./AdminDashboardLayout";
import { setupDaypass } from "../clients/setup_helper";
import {
  GOERLI_ENTRYPOINT,
  GOERLI_SETUP_HELPER,
  MUMBAI_ENTRYPOINT,
  MUMBAI_SETUP_HELPER,
} from "../consts/address";
import { BigNumber, ethers } from "ethers";
import {
  LOCALSTORAGE_KEY_DAY_PASS_ADDRESS,
  LOCALSTORAGE_PAYMASTER_ADDRESS,
} from "../consts/localstorage";

const AdminDashboardPage = () => {
  const router = useRouter();
  const { address } = useAccount();

  const { register, handleSubmit, watch } = useForm();
  const watchAllFields = watch();
  const [submitting, setSubmitting] = useState(false);
  const { chain } = useNetwork();

  const { data: signer } = useSigner();

  const getSetupHelperAndEntryPoint = (chainName: string) => {
    switch (chainName) {
      case "goerli":
        return [GOERLI_SETUP_HELPER, GOERLI_ENTRYPOINT] as const;
      case "maticmum":
        return [MUMBAI_SETUP_HELPER, MUMBAI_ENTRYPOINT] as const;
    }

    return ["", ""];
  };

  const onSubmit = (values: any, e?: React.BaseSyntheticEvent) => {
    e?.preventDefault();

    const {
      contract,
      network,
      enableTransfer,
      enableTrade,
      enableGasLimit,
      enableSpendingLimit,
      enableTimeLimit,
    } = values;

    let gasLimit = BigNumber.from(0);
    if (enableGasLimit) {
      gasLimit = values.gasLimitAmount
        ? ethers.utils.parseUnits(values.gasLimitAmount, "gwei")
        : BigNumber.from(0);
    }

    let spendingLimit = 0;
    if (enableSpendingLimit) {
      spendingLimit = values.spendingLimitAmount
        ? Number.parseInt(values.spendingLimitAmount)
        : 0;
    }

    let timeLimit = 0;
    if (enableTimeLimit) {
      switch (values.timeLimit) {
        case "week":
          timeLimit = 3600 * 24 * 7;
        case "month":
          timeLimit = 3600 * 24 * 30;
        case "3_months":
          timeLimit = 3600 * 24 * 30 * 3;
      }
    }

    console.log({
      contract,
      network,
      enableTransfer,
      enableTrade,
      gasLimit,
      spendingLimit,
      timeLimit,
    });

    (async () => {
      setSubmitting(true);

      try {
        const [setupHelper, entryPoint] = getSetupHelperAndEntryPoint(
          chain?.network!
        );

        const { passNFT, paymaster } = await setupDaypass(
          signer!,
          setupHelper!,
          entryPoint!,
          {
            targets: [contract],
            transferable: enableTransfer,
            gasLimitPerOperation: gasLimit,
            spendingLimitPerOperation: spendingLimit,
            timeLimitPerOperation: timeLimit,
            holders: [],
          }
        );

        const chainName = (chain?.network ?? "").toUpperCase();

        console.log(
          `Saved ${passNFT} into localstorage ${LOCALSTORAGE_KEY_DAY_PASS_ADDRESS}`
        );

        console.log(
          `Saved ${passNFT} into localstorage ${LOCALSTORAGE_KEY_DAY_PASS_ADDRESS}_${chainName}`
        );

        localStorage.setItem(
          `${LOCALSTORAGE_PAYMASTER_ADDRESS}_${chainName}`,
          paymaster
        );

        console.log(
          `Saved ${paymaster} into localstorage ${LOCALSTORAGE_PAYMASTER_ADDRESS}${chainName}`
        );

        router.push("/airdrop");
      } catch (error) {
        console.error(error);
      } finally {
        setSubmitting(false);
      }
    })();
  };

  console.log("chain?.network", chain?.network);

  return (
    <AdminDashboardLayout>
      <form onSubmit={handleSubmit(onSubmit)}>
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
                      lineHeight="1.5"
                      fontWeight="regular"
                      fontSize="24px"
                      letterSpacing="-0.02em"
                      color="#000000"
                    >
                      Configure Daypasses
                    </Text>
                  </Heading>
                  <Flex
                    alignItems="center"
                    justifyContent="space-between"
                    minW="235px"
                  >
                    <Circle size="28px" background="#0075FF">
                      <Text
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
                        lineHeight="1.5"
                        fontWeight="regular"
                        fontSize="18px"
                        letterSpacing="-0.02em"
                        color="#000000"
                        mb="2"
                      >
                        Allowed Address
                      </Text>
                    </Heading>
                    <Input
                      disabled={submitting}
                      placeholder="Paste your Contract Address"
                      size="lg"
                      width="548px"
                      height="48px"
                      maxWidth="100%"
                      {...register("contract")}
                    />
                  </Box>
                  <Box w="320px" pl="5">
                    <Heading variant="h2">
                      <Text
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
                    <Select
                      disabled={submitting}
                      placeholder="Specify Network"
                      size="lg"
                      defaultValue={chain?.network ?? "goerli"}
                      {...register("network")}
                    >
                      <option value="goerli">Goerli</option>
                      <option value="maticmum">Mumbai</option>
                      <option value="ethereum">Ethereum</option>
                    </Select>
                  </Box>
                </Flex>
                <Heading variant="h2">
                  <Text
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
                      <Text lineHeight="1.5" fontSize="16px">
                        Type
                      </Text>
                    </Heading>
                    <Heading variant="h3" w="50%">
                      <Text lineHeight="1.5" fontSize="16px">
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
                        <Text lineHeight="1.5" fontSize="16px">
                          Allow to transfer
                        </Text>
                      </Heading>
                      <Text
                        lineHeight="1.5"
                        fontWeight="regular"
                        fontSize="16px"
                        color="#A0AEC0"
                      >
                        Make Day Pass NFTs transferable or soulbound.
                      </Text>
                    </Box>
                    <Stack
                      direction="row"
                      justify="left"
                      align="center"
                      w="50%"
                    >
                      <Text
                        lineHeight="1.5"
                        fontWeight="regular"
                        fontSize="16px"
                        letterSpacing="-0.02em"
                        color="#000000"
                      >
                        Off
                      </Text>
                      <Switch
                        isDisabled={submitting}
                        {...register("enableTransfer")}
                      />
                      <Text
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
                        <Text lineHeight="1.5" fontSize="16px">
                          Allow to trade
                        </Text>
                      </Heading>
                      <Text
                        lineHeight="1.5"
                        fontWeight="regular"
                        fontSize="16px"
                        color="#A0AEC0"
                      >
                        Block or allow trading.
                      </Text>
                    </Box>
                    <Stack
                      direction="row"
                      justify="left"
                      align="center"
                      w="50%"
                    >
                      <Text
                        lineHeight="1.5"
                        fontWeight="regular"
                        fontSize="16px"
                        letterSpacing="-0.02em"
                        color="#000000"
                      >
                        Off
                      </Text>
                      <Switch
                        isDisabled={submitting}
                        {...register("enableTrade")}
                      />
                      <Text
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
                        <Text lineHeight="1.5" fontSize="16px">
                          Gas limit
                        </Text>
                      </Heading>
                      <Text
                        lineHeight="1.5"
                        fontWeight="regular"
                        fontSize="16px"
                        color="#A0AEC0"
                      >
                        Specify a maximum gas limit you want your users to
                        spend.
                      </Text>
                    </Box>

                    <Stack
                      direction="row"
                      justify="left"
                      align="center"
                      w="50%"
                    >
                      <Box w="40%">
                        <Stack direction="row" justify="left" align="center">
                          <Text
                            lineHeight="1.5"
                            fontWeight="regular"
                            fontSize="16px"
                            letterSpacing="-0.02em"
                            color="#000000"
                          >
                            Off
                          </Text>
                          <Switch
                            isDisabled={submitting}
                            {...register("enableGasLimit")}
                          />
                          <Text
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
                          <Input
                            isDisabled={submitting}
                            type="gaslimit"
                            placeholder="0"
                            disabled={!watchAllFields.enableGasLimit}
                            {...register("gasLimitAmount")}
                          />
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
                        <Text lineHeight="1.5" fontSize="16px">
                          Spending limit
                        </Text>
                      </Heading>
                      <Text
                        lineHeight="1.5"
                        fontWeight="regular"
                        fontSize="16px"
                        color="#A0AEC0"
                      >
                        Specify a maximum spending limit for user per single
                        transaction.
                      </Text>
                    </Box>
                    <Stack
                      direction="row"
                      justify="left"
                      align="center"
                      w="50%"
                    >
                      <Box w="40%">
                        <Stack direction="row" justify="left" align="center">
                          <Text
                            lineHeight="1.5"
                            fontWeight="regular"
                            fontSize="16px"
                            letterSpacing="-0.02em"
                            color="#000000"
                          >
                            Off
                          </Text>
                          <Switch
                            disabled={submitting}
                            {...register("enableSpendingLimit")}
                          />
                          <Text
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
                          <Input
                            isDisabled={submitting}
                            type="spendinglimit"
                            placeholder="0"
                            disabled={!watchAllFields.enableSpendingLimit}
                            {...register("spendingLimitAmount")}
                          />
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
                        <Text lineHeight="1.5" fontSize="16px">
                          Time limit
                        </Text>
                      </Heading>
                      <Text
                        lineHeight="1.5"
                        fontWeight="regular"
                        fontSize="16px"
                        color="#A0AEC0"
                      >
                        Setup a timeframe after which NFT will expire.
                      </Text>
                    </Box>
                    <Stack
                      direction="row"
                      justify="left"
                      align="center"
                      w="50%"
                    >
                      <Box w="40%">
                        <Stack direction="row" justify="left" align="center">
                          <Text
                            lineHeight="1.5"
                            fontWeight="regular"
                            fontSize="16px"
                            letterSpacing="-0.02em"
                            color="#000000"
                          >
                            Off
                          </Text>
                          <Switch
                            disabled={submitting}
                            {...register("enableTimeLimit")}
                          />
                          <Text
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
                        <RadioGroup isDisabled={submitting}>
                          <Stack direction="row">
                            <Radio value="week" {...register("timeLimit")}>
                              <Text
                                lineHeight="1.5"
                                fontWeight="regular"
                                fontSize="14px"
                                letterSpacing="-0.02em"
                                color="#000000"
                              >
                                Week
                              </Text>
                            </Radio>
                            <Radio value="month" {...register("timeLimit")}>
                              <Text
                                lineHeight="1.5"
                                fontWeight="regular"
                                fontSize="14px"
                                letterSpacing="-0.02em"
                                color="#000000"
                              >
                                Month
                              </Text>
                            </Radio>
                            <Radio value="3_months" {...register("timeLimit")}>
                              <Text
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
              <Flex justify="flex-end" mt="8" mb="12">
                <Button
                  colorScheme="blue"
                  type="submit"
                  width="206px"
                  height="40px"
                  isLoading={submitting}
                  isDisabled={!address}
                >
                  Next
                </Button>
              </Flex>
            </FormControl>
          </Box>
        </Flex>
      </form>
    </AdminDashboardLayout>
  );
};

export default AdminDashboardPage;
