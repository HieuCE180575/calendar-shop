import '../repositories/favorite_repository.dart';

class CheckFavoriteUseCase {
  final FavoriteRepository repository;

  CheckFavoriteUseCase(this.repository);

  Future<bool> call(int productId) {
    return repository.checkFavorite(productId);
  }
}
