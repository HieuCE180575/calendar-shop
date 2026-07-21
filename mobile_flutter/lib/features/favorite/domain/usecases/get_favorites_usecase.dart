import '../entities/favorite.dart';
import '../repositories/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<Favorite>> call() {
    return repository.getFavorites();
  }
}
