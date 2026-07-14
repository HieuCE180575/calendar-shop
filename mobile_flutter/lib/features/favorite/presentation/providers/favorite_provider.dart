import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/favorite_remote_datasource.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorite_repository.dart';

final favoriteRemoteDataSourceProvider = Provider<FavoriteRemoteDataSource>((ref) {
  return FavoriteRemoteDataSource(ref.watch(apiClientProvider));
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(ref.watch(favoriteRemoteDataSourceProvider));
});

final favoriteListProvider = FutureProvider.autoDispose<List<Favorite>>((ref) async {
  return ref.watch(favoriteRepositoryProvider).getFavorites();
});

final checkFavoriteProvider = FutureProvider.family.autoDispose<bool, int>((ref, productId) async {
  return ref.watch(favoriteRepositoryProvider).checkFavorite(productId);
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
      final repo = ref.read(favoriteRepositoryProvider);
      if (isCurrentlyFavorite) {
        await repo.removeFavorite(productId);
      } else {
        await repo.addFavorite(productId);
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
