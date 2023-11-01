import 'package:sqflite/sqflite.dart';
import 'package:workmanager_service_poc/data/db/constants_db.dart';

void createIndexProdutoV1_02_00_Produto({required Batch batch}) {
  batch.execute('''
    create index produto_index_descricao on '$productTableName' (descricao)
  ''');
}
