class Result<Success, Error> {
  final Error error;
  final Success result;

  bool get isSuccess => error == null;

  const Result.success(this.result) : error = null;

  const Result.error(this.error) : result = null;
}
