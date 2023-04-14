const withTM = require("next-transpile-modules")([
  "@zerodevapp/wagmi",
  "@zerodevapp/social-wallet",
]);

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
};

module.exports = withTM({
  ...nextConfig,
  webpack5: true,
});
