import '../repositories/admin_dashboard_repository.dart';

class ExportRevenueExcelUseCase {
  final AdminDashboardRepository repository;

  ExportRevenueExcelUseCase(this.repository);

  Future<List<int>> call() {
    return repository.exportRevenueExcel();
  }
}
