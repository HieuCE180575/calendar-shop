import '../../domain/repositories/address_repository.dart';

class SetDefaultAddressUseCase {
  final AddressRepository repository;
  SetDefaultAddressUseCase(this.repository);

  Future<void> call(int id) => repository.setDefaultAddress(id);
}
