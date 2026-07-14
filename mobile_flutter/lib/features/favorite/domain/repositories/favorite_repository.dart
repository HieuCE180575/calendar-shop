import '../entities/favorite.dart';

abstract class FavoriteRepository {
  Future<List<Favorite>> getFavorites();
  Future<void> addFavorite(int productId);
  Future<void> removeFavorite(int productId);
  Future<bool> checkFavorite(int productId);
}
