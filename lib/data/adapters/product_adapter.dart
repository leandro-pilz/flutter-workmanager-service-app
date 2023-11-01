import 'package:workmanager_service_poc/core/entities/product_entity.dart';
import 'package:workmanager_service_poc/core/utils/extensions.dart';

base class ProductAdapter {
  ProductEntity _mapToProductEntity({required Map<String, dynamic> map}) {
    final profitMargin = (map['margem'] is int)
        ? (map['margem'] as int).toDouble()
        : map['margem'];

    final packaging = (map['embalagem'] is int)
        ? (map['embalagem'] as int).toDouble()
        : map['embalagem'];

    late DateTime created;
    late DateTime updated;
    if (map['data_criacao'] == null) {
      created = DateTime.now();
      updated = created;
    } else {
      created = (map['data_criacao'] as int).convertIntDateToDateTime();
      updated = (map['data_alteracao'] as int).convertIntDateToDateTime();
    }

    return ProductEntity(
      id: map['id'],
      code: map['codigo'],
      description: map['descricao'],
      profitMargin: profitMargin,
      packaging: packaging,
      unitOfMeasurement: map['unidade_medida'],
      linkImage: map['link_imagem'],
      created: created,
      updated: updated,
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

  List<Map<String, dynamic>> listProductEntityToMapList({
    required List<ProductEntity> products,
  }) {
    return products
        .map((e) => {
              "id": e.id,
              "codigo": e.code,
              "descricao": e.description,
              "margem": e.profitMargin,
              "embalagem": e.packaging,
              "unidade_medida": e.unitOfMeasurement,
              "link_imagem": e.linkImage,
              "data_criacao": e.created?.convertDateTimeToInt(),
              "data_alteracao": e.updated?.convertDateTimeToInt(),
            })
        .toList();
  }
}
