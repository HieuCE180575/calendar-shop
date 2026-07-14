// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_rating_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductRatingSummaryModelImpl _$$ProductRatingSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductRatingSummaryModelImpl(
      productId: (json['productId'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      star1: (json['star1'] as num).toInt(),
      star2: (json['star2'] as num).toInt(),
      star3: (json['star3'] as num).toInt(),
      star4: (json['star4'] as num).toInt(),
      star5: (json['star5'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductRatingSummaryModelImplToJson(
        _$ProductRatingSummaryModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'star1': instance.star1,
      'star2': instance.star2,
      'star3': instance.star3,
      'star4': instance.star4,
      'star5': instance.star5,
    };
