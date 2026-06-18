import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Keep Prisma's engine out of the server bundle so it loads correctly on
  // Vercel's serverless runtime.
  serverExternalPackages: ["@prisma/client", "prisma"],
};

export default nextConfig;
