abstract interface class Api<T> {
  Future<T> get({required String url});
}
