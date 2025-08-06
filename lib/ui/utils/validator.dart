class Validator {
  static bool validateMail(String? value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    if (emailRegex.hasMatch(value!)) {
      return false;
    }
    return true;
  }

  static bool passValidator(String value) {
    if (value.length < 7) {
      return true;
    }
    return false;
  }

  static bool pinValidator(String value) {
    if (value.length < 6) {
      true;
    }
    return false;
  }
}
