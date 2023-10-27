import 'package:workmanager_service_poc/core/entities/entity.dart';

base class ProductEntity extends Entity {
  final String code;
  final String description;
  final double profitMargin;
  final double packaging;
  final String unitOfMeasurement;
  final String linkImage;

  ProductEntity({
    required this.code,
    required this.description,
    required this.profitMargin,
    required this.packaging,
    required this.unitOfMeasurement,
    required this.linkImage,
  });
}
