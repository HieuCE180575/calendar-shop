import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/address.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required int addressId,
    required int userId,
    required String receiverName,
    required String receiverPhone,
    required String province,
    required String district,
    String? ward,
    required String addressLine,
    required bool isDefault,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  const AddressModel._();

  Address toEntity() {
    return Address(
      addressId: addressId,
      userId: userId,
      receiverName: receiverName,
      receiverPhone: receiverPhone,
      province: province,
      district: district,
      ward: ward,
      addressLine: addressLine,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory AddressModel.fromEntity(Address entity) {
    return AddressModel(
      addressId: entity.addressId,
      userId: entity.userId,
      receiverName: entity.receiverName,
      receiverPhone: entity.receiverPhone,
      province: entity.province,
      district: entity.district,
      ward: entity.ward,
      addressLine: entity.addressLine,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
