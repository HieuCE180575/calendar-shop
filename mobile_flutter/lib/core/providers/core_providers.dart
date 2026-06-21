import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(TokenStorageRef ref) => TokenStorage();

@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient(tokenStorage: ref.watch(tokenStorageProvider));
}
