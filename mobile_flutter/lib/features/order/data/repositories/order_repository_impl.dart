import '../../../../core/network/api_client.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final ApiClient apiClient; // for handleError

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.apiClient,
  });

  @override
  Future<List<OrderEntity>> getMyOrders() async {
    try {
      final models = await remoteDataSource.getMyOrders();
      return models.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  @override
  Future<void> reorder(int orderId) async {
    try {
      await remoteDataSource.reorder(orderId);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
