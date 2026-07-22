import '../../domain/repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;
  DeleteAddressUseCase(this.repository);

  Future<void> call(int id) => repository.deleteAddress(id);
}
