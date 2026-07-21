import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/favorite_remote_datasource.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/check_favorite_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';

final favoriteRemoteDataSourceProvider = Provider<FavoriteRemoteDataSource>((ref) {
  return FavoriteRemoteDataSource(ref.watch(apiClientProvider));
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(ref.watch(favoriteRemoteDataSourceProvider));
});

final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>((ref) {
  return GetFavoritesUseCase(ref.watch(favoriteRepositoryProvider));
});

final checkFavoriteUseCaseProvider = Provider<CheckFavoriteUseCase>((ref) {
  return CheckFavoriteUseCase(ref.watch(favoriteRepositoryProvider));
});

final addFavoriteUseCaseProvider = Provider<AddFavoriteUseCase>((ref) {
  return AddFavoriteUseCase(ref.watch(favoriteRepositoryProvider));
});

final removeFavoriteUseCaseProvider = Provider<RemoveFavoriteUseCase>((ref) {
  return RemoveFavoriteUseCase(ref.watch(favoriteRepositoryProvider));
});

final favoriteListProvider = FutureProvider.autoDispose<List<Favorite>>((ref) async {
  return ref.watch(getFavoritesUseCaseProvider)();
});

final checkFavoriteProvider = FutureProvider.family.autoDispose<bool, int>((ref, productId) async {
  return ref.watch(checkFavoriteUseCaseProvider)(productId);
});

class FavoriteActionState {
  final bool isLoading;
  final String? error;

  const FavoriteActionState({
    this.isLoading = false,
    this.error,
  });
}

class FavoriteActionNotifier extends StateNotifier<FavoriteActionState> {
  final Ref ref;

  FavoriteActionNotifier(this.ref) : super(const FavoriteActionState());

  Future<bool> toggleFavorite(int productId, bool isCurrentlyFavorite) async {
    state = const FavoriteActionState(isLoading: true);
    try {
      if (isCurrentlyFavorite) {
        await ref.read(removeFavoriteUseCaseProvider)(productId);
      } else {
        await ref.read(addFavoriteUseCaseProvider)(productId);
      }
      state = const FavoriteActionState();
      
      // Refresh the specific check provider and the list provider
      ref.invalidate(checkFavoriteProvider(productId));
      ref.invalidate(favoriteListProvider);
      return true;
    } catch (e) {
      state = FavoriteActionState(error: e.toString());
      return false;
    }
  }
}

final favoriteActionNotifierProvider =
    StateNotifierProvider<FavoriteActionNotifier, FavoriteActionState>((ref) {
  return FavoriteActionNotifier(ref);
});
