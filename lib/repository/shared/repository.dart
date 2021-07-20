abstract class Repository {
  Future<List> fetchAll();
  Future<bool> insert(Object data);
  Future<bool> update(Object data);
  Future<bool> delete(Object data);
}