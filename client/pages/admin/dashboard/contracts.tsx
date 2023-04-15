import { useRouter } from "next/router";
import { useEffect } from "react";
import { useAccount } from "wagmi";
import AdminDashboardLayout from "./AdminDashboardLayout";

const AdminDashboardPage = () => {
  const router = useRouter();
  const { address } = useAccount();

  useEffect(() => {
    if (!address) {
      router.push("/admin/dashboard");
    }
  }, [address]);

  return <AdminDashboardLayout>Contract page</AdminDashboardLayout>;
};

export default AdminDashboardPage;
