import 'package:sqflite/sqflite.dart';
import 'package:workmanager_service_poc/data/db/constants_db.dart';

void createProdutoV1_01_00_Produto({required Batch batch}) {
  batch.execute('''
      create table '$productTableName'
      (
          id             integer PRIMARY KEY AUTOINCREMENT not null,
          codigo         text                not null constraint produto_uk_codigo unique,
          descricao      text collate NOCASE not null,
          margem         real                not null,
          embalagem      real                not null,
          unidade_medida text                not null,
          link_imagem    text                not null,
          data_criacao   integer             not null,
          data_alteracao integer             not null
      );
  ''');
}
