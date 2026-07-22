import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';

class AddAddressUseCase {
  final AddressRepository repository;
  AddAddressUseCase(this.repository);

  Future<Address> call({
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
  }) => repository.createAddress(
    receiverName: receiverName,
    receiverPhone: receiverPhone,
    province: province,
    district: district,
    ward: ward,
    addressLine: addressLine,
    isDefault: isDefault,
  );
}
