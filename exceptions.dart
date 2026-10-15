
class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => message;
}

class UnpaidFinesException implements Exception {
  @override
  String toString() => "You should pay your fine first";
}

class ReservationNotAllowedException implements Exception {
  @override
  String toString() => "This reservation is not allowed";
}

class ItemNotFoundException implements Exception {
  @override
  String toString() => "This item was not found";
}

class ItemNotAvailableException implements Exception {
  @override
  String toString() => "This item is not available";
}

class InvalidPaymentException implements Exception {
  @override
  String toString() => "Invalid payment";
}

class BorrowLimitExceededException implements Exception {
  @override
  String toString() => "Borrowing limit exceeded";
}
