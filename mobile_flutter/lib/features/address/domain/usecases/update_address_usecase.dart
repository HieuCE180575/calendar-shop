import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;
  UpdateAddressUseCase(this.repository);

  Future<Address> call({
    required int addressId,
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
  }) => repository.updateAddress(
    addressId: addressId,
    receiverName: receiverName,
    receiverPhone: receiverPhone,
    province: province,
    district: district,
    ward: ward,
    addressLine: addressLine,
    isDefault: isDefault,
  );
}
