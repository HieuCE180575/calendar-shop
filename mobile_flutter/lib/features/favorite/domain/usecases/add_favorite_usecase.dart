import '../repositories/favorite_repository.dart';

class AddFavoriteUseCase {
  final FavoriteRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call(int productId) {
    return repository.addFavorite(productId);
  }
}
