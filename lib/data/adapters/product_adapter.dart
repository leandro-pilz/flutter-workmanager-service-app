import 'package:workmanager_service_poc/core/entities/product_entity.dart';

base class ProductAdapter {
  ProductEntity _mapToProductEntity({required Map<String, dynamic> map}) {
    final profitMargin = (map['margem'] is int)
        ? (map['margem'] as int).toDouble()
        : map['margem'];

    final packaging = (map['embalagem'] is int)
        ? (map['embalagem'] as int).toDouble()
        : map['embalagem'];

    return ProductEntity(
      code: map['codigo'],
      description: map['descricao'],
      profitMargin: profitMargin,
      packaging: packaging,
      unitOfMeasurement: map['unidade_medida'],
      linkImage: map['link_imagem'],
    );
  }

  List<ProductEntity> mapListToListProductEntity({
    required Map<String, dynamic> map,
  }) {
    final List<ProductEntity> products = [];
    for (var product in map['data']) {
      products.add(_mapToProductEntity(map: product));
    }

    return products;
  }
}
