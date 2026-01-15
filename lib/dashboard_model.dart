class DashboardStats {
  final int dailyOrders;
  final int activeUsers;
  final double totalRevenue;

  DashboardStats({
    required this.dailyOrders,
    required this.activeUsers,
    required this.totalRevenue,
  });
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final String status;
  final String description;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
    required this.description,
  });
}
