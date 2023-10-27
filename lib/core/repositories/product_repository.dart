import 'package:workmanager_service_poc/core/entities/product_entity.dart';

abstract interface class ProductRepository {
  Future<List<ProductEntity>> getAll({required int userId});
}
