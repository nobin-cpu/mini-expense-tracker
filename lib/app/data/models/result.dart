class Result<T> {
  const Result.ok(this.data) : error = null;

  const Result.fail(this.error) : data = null;

  final T? data;
  final String? error;

  bool get success => error == null;

  bool get failed => !success;
}
