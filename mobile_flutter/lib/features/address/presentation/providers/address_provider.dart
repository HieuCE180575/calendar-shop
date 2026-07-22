import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/address_remote_datasource.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/add_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';
import '../../domain/entities/address.dart';

part 'address_provider.g.dart';

@riverpod
AddressRemoteDataSource addressRemoteDataSource(AddressRemoteDataSourceRef ref) {
  return AddressRemoteDataSource(ref.watch(apiClientProvider));
}

@riverpod
AddressRepository addressRepository(AddressRepositoryRef ref) {
  return AddressRepositoryImpl(ref.watch(addressRemoteDataSourceProvider));
}

@riverpod
GetAddressesUseCase getAddressesUseCase(GetAddressesUseCaseRef ref) {
  return GetAddressesUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
AddAddressUseCase addAddressUseCase(AddAddressUseCaseRef ref) {
  return AddAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
UpdateAddressUseCase updateAddressUseCase(UpdateAddressUseCaseRef ref) {
  return UpdateAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
DeleteAddressUseCase deleteAddressUseCase(DeleteAddressUseCaseRef ref) {
  return DeleteAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
SetDefaultAddressUseCase setDefaultAddressUseCase(SetDefaultAddressUseCaseRef ref) {
  return SetDefaultAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
class AddressList extends _$AddressList {
  @override
  FutureOr<List<Address>> build() {
    return ref.watch(getAddressesUseCaseProvider)();
  }

  Future<void> addAddress({
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(addAddressUseCaseProvider)(
        receiverName: receiverName,
        receiverPhone: receiverPhone,
        province: province,
        district: district,
        ward: ward,
        addressLine: addressLine,
        isDefault: isDefault,
      );
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAddress({
    required int addressId,
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(updateAddressUseCaseProvider)(
        addressId: addressId,
        receiverName: receiverName,
        receiverPhone: receiverPhone,
        province: province,
        district: district,
        ward: ward,
        addressLine: addressLine,
        isDefault: isDefault,
      );
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAddress(int id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(deleteAddressUseCaseProvider)(id);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setDefaultAddress(int id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(setDefaultAddressUseCaseProvider)(id);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
