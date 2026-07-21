import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_result_model.freezed.dart';
part 'message_result_model.g.dart';

@freezed
class MessageResultModel with _$MessageResultModel {
  const factory MessageResultModel({
    required String message,
  }) = _MessageResultModel;

  factory MessageResultModel.fromJson(Map<String, dynamic> json) =>
      _$MessageResultModelFromJson(json);
}
