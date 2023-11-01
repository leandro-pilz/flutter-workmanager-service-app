import 'dart:developer';

import 'package:workmanager_service_poc/core/db/data_base_helper.dart';
import 'package:workmanager_service_poc/core/http/api.dart';
import 'package:workmanager_service_poc/core/entities/product_entity.dart';
import 'package:workmanager_service_poc/core/repositories/product_repository.dart';
import 'package:workmanager_service_poc/data/adapters/product_adapter.dart';
import 'package:workmanager_service_poc/data/db/constants_db.dart';

base class ProductRepositoryImp implements ProductRepository {
  final Api api;
  final DataBaseHelper dataBase;

  ProductRepositoryImp({required this.api, required this.dataBase});
  @override
  Future<List<ProductEntity>> getAll({required int userId}) async {
    try {
      final String url =
          'https://app.dinac.com.br:4443/ords/benkyou_erp_cli/v1.1/products/$userId';
      final result = await api.get(url: url);
      return ProductAdapter().mapListToListProductEntity(map: result);
    } catch (e) {
      log('Ocorreu um erro $e');
      rethrow;
    }
  }

  @override
  Future<void> saveAll({required List<ProductEntity> produtcs}) async {
    try {
      final data =
          ProductAdapter().listProductEntityToMapList(products: produtcs);
      await dataBase.createAllBy(
        tableName: productTableName,
        values: data,
        isKeysRequired: true,
        keys: ["codigo"],
      );
    } catch (e) {
      log('Ocorreu um erro $e');
      rethrow;
    }
  }
}
