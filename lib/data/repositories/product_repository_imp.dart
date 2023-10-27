import 'dart:developer';

import 'package:workmanager_service_poc/core/api.dart';
import 'package:workmanager_service_poc/core/entities/product_entity.dart';
import 'package:workmanager_service_poc/core/repositories/product_repository.dart';
import 'package:workmanager_service_poc/data/adapters/product_adapter.dart';

base class ProductRepositoryImp implements ProductRepository {
  final Api api;

  ProductRepositoryImp({required this.api});
  @override
  Future<List<ProductEntity>> getAll({required int userId}) async {
    try {
      final String url =
          'https://app.dinac.com.br:4443/ords/benkyou_erp_cli/v1.1/products/$userId';
      final result = await api.get(url: url);
      return ProductAdapter().mapListToListProductEntity(map: result);
    } catch (e) {
      log('Ocorreu um erro $e');
      return [];
    }
  }
}
