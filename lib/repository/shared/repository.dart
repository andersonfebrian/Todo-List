abstract class Repository {
  Future<List> fetchAll();
  Future<bool> insert(data);
  Future<bool> update(data);
  Future<bool> delete(data);
}