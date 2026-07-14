import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_remote_datasource.dart';
import '../models/favorite_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Favorite>> getFavorites() async {
    final models = await remoteDataSource.getFavorites();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addFavorite(int productId) async {
    return remoteDataSource.addFavorite(productId);
  }

  @override
  Future<void> removeFavorite(int productId) async {
    return remoteDataSource.removeFavorite(productId);
  }

  @override
  Future<bool> checkFavorite(int productId) async {
    return remoteDataSource.checkFavorite(productId);
  }
}
