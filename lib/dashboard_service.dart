import 'dart:math';
import 'dashboard_model.dart';

class DashboardService {
  // Simulate API delay
  Future<DashboardStats> fetchDashboardStats() async {
    await Future.delayed(const Duration(seconds: 1)); // Mock network delay

    // Mock data
    return DashboardStats(
      dailyOrders: 125,
      activeUsers: 843,
      totalRevenue: 15430000,
    );
  }

  Future<List<Transaction>> fetchRecentTransactions() async {
    await Future.delayed(const Duration(seconds: 1)); // Mock network delay

    return List.generate(10, (index) {
      final random = Random();
      return Transaction(
        id: 'TRX-${1000 + index}',
        amount: (random.nextInt(100) + 10) * 10000.0,
        date: DateTime.now().subtract(Duration(hours: index * 2)),
        status: index % 3 == 0 ? 'Pending' : 'Success',
        description: 'Pembelian Item #${index + 1}',
      );
    });
  }
}
