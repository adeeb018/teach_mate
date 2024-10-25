
import '../../../constants/constant_strings.dart';
import '../../../utils/exceptions/validation_exceptions.dart';

class AuthValidator {

  static bool validateEmail(String email) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static bool validatePassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }
}

class Validator {
  static void validateEmail(String email) {
    if (!AuthValidator.validateEmail(email)) {
      throw ValidationException(StringConstants.incorrectEmailFormat);
    }
  }

  static void validatePassword(String password) {
    if (!AuthValidator.validatePassword(password)) {
      throw ValidationException(StringConstants.incorrectPasswordFormat);
    }
  }
}