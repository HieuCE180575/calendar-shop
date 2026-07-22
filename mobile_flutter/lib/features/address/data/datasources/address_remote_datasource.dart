import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/address_model.dart';

class AddressRemoteDataSource {
  final ApiClient apiClient;

  AddressRemoteDataSource(this.apiClient);

  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.addresses);

      final List dataList;
      if (response.data is Map && (response.data as Map).containsKey('value')) {
        dataList = response.data['value'] as List;
      } else if (response.data is List) {
        dataList = response.data as List;
      } else {
        dataList = [];
      }

      return dataList.map((e) => AddressModel.fromJson(e)).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<AddressModel> getAddressById(int addressId) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.addresses}/$addressId');
      return AddressModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<AddressModel> createAddress(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.addresses, data: data);
      return AddressModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<AddressModel> updateAddress(int addressId, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.put('${ApiConstants.addresses}/$addressId', data: data);
      return AddressModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> deleteAddress(int addressId) async {
    try {
      await apiClient.dio.delete('${ApiConstants.addresses}/$addressId');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> setDefaultAddress(int addressId) async {
    try {
      await apiClient.dio.patch('${ApiConstants.addresses}/$addressId/default');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
