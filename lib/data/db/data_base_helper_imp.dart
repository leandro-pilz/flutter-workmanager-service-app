import 'package:sqflite/sqflite.dart';
import 'package:workmanager_service_poc/core/utils/extensions.dart';

import '../../core/db/data_base_helper.dart';
import '../../core/db/exception_db.dart';
import 'migrations/V_1/migration_v1_01_00_produto.dart';
import 'migrations/V_1/migration_v1_02_00_token_usuario.dart';

class DataBaseHelperImp implements DataBaseHelper {
  static const _databaseName = "nacional.db";
  static const _databaseVersion = 1;

  late Database _db;

  DataBaseHelperImp() {
    _initDb();
  }

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _initDb() async {
    _db = await openDatabase(
      _databaseName,
      onConfigure: onConfigure,
      version: _databaseVersion,
      onCreate: (dataBase, version) async {
        final batch = dataBase.batch();
        createProdutoV1_01_00_Produto(batch: batch);
        createIndexProdutoV1_02_00_Produto(batch: batch);
        await batch.commit();
      },
      onUpgrade: (dataBase, int oldVersion, int newVersion) {},
    );
  }

  @override
  Future<bool> isOpen() async {
    return _db.isOpen;
  }

  @override
  Future<void> close() async {
    await _db.close();
  }

  @override
  Future<Map> findBy({
    required String tableName,
    required Map<String, dynamic> params,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<Map>> findAllBy(
      {required String tableName, required Map<String, dynamic> params}) async {
    throw UnimplementedError();
  }

  Future<List<Map>> _executeABy({
    required Transaction transaction,
    required String tableName,
    Map<String, dynamic>? params,
  }) async {
    final where = params?.keys
        .fold('', (previousValue, key) => '$previousValue$key = ? ');
    final whereArgs = params?.values.map((e) => e).toList();
    return await transaction.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<bool> createAllBy({
    required String tableName,
    List<String>? keys,
    bool? isKeysRequired,
    required List<Map<String, dynamic>> values,
  }) async {
    try {
      if ((isKeysRequired ?? false) && keys == null) {
        throw ParametersRequiredError(
          message: 'Obrigatória a passagem de parâmetros!',
        );
      }

      await _db.transaction((txn) async {
        final existsData = await _executeABy(
          transaction: txn,
          tableName: tableName,
        );

        if (existsData.isEmpty) {
          for (var line in values) {
            await txn.insert(tableName, line);
          }
        } else {
          for (var line in values) {
            final code = !(isKeysRequired ?? false)
                ? null
                : line.entries
                    .where((element) => keys!.contains(element.key))
                    .map((e) => {e.key: e.value});

            final data = !(isKeysRequired ?? false)
                ? []
                : await _executeABy(
                    transaction: txn,
                    tableName: tableName,
                    params: code!.elementAt(0),
                  );

            if (data.isEmpty) {
              await txn.insert(tableName, line);
            } else {
              line['id'] = data.first['id'];
              line['data_alteracao'] = DateTime.now().convertDateTimeToInt();
              await txn.update(
                tableName,
                line,
                where: 'id = ? ',
                whereArgs: [line['id']],
              );
            }
          }
        }
      });
    } on DatabaseException catch (e) {
      _exceptions(exceptions: e);
    }

    return true;
  }

  @override
  Future<bool> updateAllBy({
    required String tableName,
    required Map<String, dynamic> args,
    required List<Map<String, dynamic>> values,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteBy(
      {required String tableName, required Map<String, dynamic> args}) {
    throw UnimplementedError();
  }

  void _exceptions({required DatabaseException exceptions}) {
    if (exceptions.isDuplicateColumnError()) {
      throw DuplicateColumnError(
          message: 'Colunas duplicadas verifique: ${exceptions.toString()}');
    }

    if (exceptions.isSyntaxError()) {
      throw SyntaxError(
          message: 'Erro de sintaxe verique: ${exceptions.toString()}');
    }

    if (exceptions.isDatabaseClosedError()) {
      throw DatabaseClosedError(
          message:
              'Banco de dados fechado verifique: ${exceptions.toString()}');
    }

    if (exceptions.isUniqueConstraintError()) {
      throw UniqueConstraintError(
          message:
              'Não é permitido duplicidade do dado, verifique: ${exceptions.toString()}');
    }

    if (exceptions.isNotNullConstraintError()) {
      throw NotNullConstraintError(
          message:
              'Não é permitido valor nulo, verifique: ${exceptions.toString()}');
    }

    throw GenericError(
        message: 'Verifique o erro não catalogado: ${exceptions.toString()}');
  }
}
