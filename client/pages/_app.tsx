import type { AppProps } from "next/app";
import { useRouter } from "next/router";
import AAWalletProvider from "../providers/aaWallet";
import WalletProvider from "../providers/wallet";

export default function App({ Component, pageProps }: AppProps) {
  const router = useRouter();

  // TODO can we consolidate these?

  if (router.pathname.startsWith("/user")) {
    return (
      <AAWalletProvider>
        <Component {...pageProps} />
      </AAWalletProvider>
    );
  }
  return (
    <WalletProvider>
      <Component {...pageProps} />
    </WalletProvider>
  );
}
