import '../entities/address.dart';

abstract class AddressRepository {
  Future<List<Address>> getAddresses();
  Future<Address> getAddressById(int addressId);
  Future<Address> createAddress({
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
  });
  Future<Address> updateAddress({
    required int addressId,
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
  });
  Future<void> deleteAddress(int addressId);
  Future<void> setDefaultAddress(int addressId);
}
