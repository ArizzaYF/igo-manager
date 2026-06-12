import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d).{8,}$',
  );

  static final RegExp _phoneRegex = RegExp(
    r'^\+?[\d\s\-()]{7,15}$',
  );

  static bool isValidEmail(String email) => _emailRegex.hasMatch(email);

  static bool isValidPassword(String password) =>
      _passwordRegex.hasMatch(password);

  static bool isValidPhone(String phone) => _phoneRegex.hasMatch(phone);

  static bool isNotEmpty(String value) => value.trim().isNotEmpty;

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!isValidEmail(email.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!isValidPassword(password)) {
      return AppStrings.invalidPassword;
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${AppStrings.fieldRequired.toLowerCase()}';
    }
    return null;
  }

  static String? validatePasswordsMatch(
      String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return null;
    }
    if (!isValidPhone(phone.trim())) {
      return AppStrings.invalidPhone;
    }
    return null;
  }
}
