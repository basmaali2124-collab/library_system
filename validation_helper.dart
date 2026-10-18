
import 'exceptions.dart';

class ValidationHelper {
  static void positiveValidation(var value, String msg) {
    if (value <= 0) {
      throw ValidationException(
        "$msg must be greater than zero",
      );
    }
  }

  static void yearValidation(int publishYear) {
    if (publishYear > DateTime.now().year) {
      throw ValidationException(
        "This year hasn't come yet",
      );
    }
  }

  static void phoneVlidation(String value) {
    if (value.length != 11 ||
        !RegExp(r'^\d+$').hasMatch(value)) {
      throw ValidationException(
        "Phone must be 11 digits only",
      );
    }
  }

  static void emailValidation(String value) {
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9]*@[a-zA-Z][a-zA-Z0-9]\.com$')
        .hasMatch(value)) {
      throw ValidationException("Invalid email");
    }
  }
}
