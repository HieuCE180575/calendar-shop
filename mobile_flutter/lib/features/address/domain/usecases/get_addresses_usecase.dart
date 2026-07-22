import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository repository;
  GetAddressesUseCase(this.repository);

  Future<List<Address>> call() => repository.getAddresses();
}
