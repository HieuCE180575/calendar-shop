import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_datasource.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Address>> getAddresses() async {
    final models = await remoteDataSource.getAddresses();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Address> getAddressById(int addressId) async {
    final model = await remoteDataSource.getAddressById(addressId);
    return model.toEntity();
  }

  @override
  Future<Address> createAddress({
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
  }) async {
    final model = await remoteDataSource.createAddress({
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'province': province,
      'district': district,
      'ward': ward,
      'addressLine': addressLine,
      'isDefault': isDefault,
    });
    return model.toEntity();
  }

  @override
  Future<Address> updateAddress({
    required int addressId,
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
  }) async {
    final model = await remoteDataSource.updateAddress(addressId, {
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'province': province,
      'district': district,
      'ward': ward,
      'addressLine': addressLine,
      'isDefault': isDefault,
    });
    return model.toEntity();
  }

  @override
  Future<void> deleteAddress(int addressId) async {
    await remoteDataSource.deleteAddress(addressId);
  }

  @override
  Future<void> setDefaultAddress(int addressId) async {
    await remoteDataSource.setDefaultAddress(addressId);
  }
}
