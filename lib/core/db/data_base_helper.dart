abstract interface class DataBaseHelper {
  Future<bool> isOpen();

  Future<void> close();

  Future<Map> findBy({
    required String tableName,
    required Map<String, dynamic> params,
  });

  Future<List<Map>> findAllBy({
    required String tableName,
    required Map<String, dynamic> params,
  });

  Future<bool> createAllBy({
    required String tableName,
    List<String>? keys,
    bool? isKeysRequired,
    required List<Map<String, dynamic>> values,
  });

  Future<bool> updateAllBy({
    required String tableName,
    required Map<String, dynamic> args,
    required List<Map<String, dynamic>> values,
  });

  Future<bool> deleteBy({
    required String tableName,
    required Map<String, dynamic> args,
  });
}
