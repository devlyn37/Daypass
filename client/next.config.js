/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  transpilePackages: ["@zerodevapp/wagmi", "@zerodevapp/social-wallet"],
};

module.exports = nextConfig;
