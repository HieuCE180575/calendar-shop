class AdminDashboardStats {
  final int totalUsers;
  final double totalRevenue;
  final int totalOrders;
  final int totalProductsSold;
  final List<StatusCount> ordersByStatus;
  final List<BestSellingProduct> bestSelling;
  final List<RevenueByDay> revenueByDay;
  final List<RevenueByMonth> revenueByMonth;
  final List<RecentOrder> recentOrders;
  final List<LowStockProduct> lowStockProducts;

  const AdminDashboardStats({
    required this.totalUsers,
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalProductsSold,
    required this.ordersByStatus,
    required this.bestSelling,
    required this.revenueByDay,
    required this.revenueByMonth,
    required this.recentOrders,
    required this.lowStockProducts,
  });
}

class StatusCount {
  final String status;
  final int total;

  const StatusCount({
    required this.status,
    required this.total,
  });
}

class BestSellingProduct {
  final int productId;
  final String productName;
  final int totalSold;

  const BestSellingProduct({
    required this.productId,
    required this.productName,
    required this.totalSold,
  });
}

class RevenueByDay {
  final DateTime date;
  final double revenue;
  final int orderCount;

  const RevenueByDay({
    required this.date,
    required this.revenue,
    required this.orderCount,
  });
}

class RevenueByMonth {
  final int year;
  final int month;
  final double revenue;
  final int orderCount;

  const RevenueByMonth({
    required this.year,
    required this.month,
    required this.revenue,
    required this.orderCount,
  });
}

class RecentOrder {
  final int orderId;
  final String customerName;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const RecentOrder({
    required this.orderId,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });
}

class LowStockProduct {
  final int productId;
  final String productName;
  final int stockQuantity;

  const LowStockProduct({
    required this.productId,
    required this.productName,
    required this.stockQuantity,
  });
}
