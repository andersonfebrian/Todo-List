abstract class Repository {
  Future<bool> insert(data);
  Future<bool> update(data);
  Future<bool> delete(data);
  Stream fetch();
}
