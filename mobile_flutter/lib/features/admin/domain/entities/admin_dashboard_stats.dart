class AdminDashboardStats {
  final double totalRevenue;
  final int totalOrders;
  final int totalProductsSold;
  final List<StatusCount> ordersByStatus;
  final List<BestSellingProduct> bestSelling;
  final List<RevenueByDay> revenueByDay;
  final List<RevenueByMonth> revenueByMonth;

  const AdminDashboardStats({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalProductsSold,
    required this.ordersByStatus,
    required this.bestSelling,
    required this.revenueByDay,
    required this.revenueByMonth,
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
