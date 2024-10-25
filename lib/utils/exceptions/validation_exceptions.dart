
class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => message;
}

class FireStoreException implements Exception {
  final String message;

  FireStoreException(this.message);

  @override
  String toString() => message;
}