class Validator {
  /// Returns [true] if email is valid, [false] otherwise
  ///
  /// [email] the email to validate
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email) && email.isNotEmpty;
  }

  /// Returns [true] if password is valid, [false] otherwise
  /// Valid password need both lower and uppercase letters, one or more
  /// numbers and has to be between 8 and 20 characters.
  ///
  /// [password] the email to validate
  static bool isValidPassword(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  /// Returns [true] if username is valid, [false] otherwise
  /// Valid usernames needs to be between 6 and 18 characters, can contain
  /// letters, numbers, underscore and period. However it cannot start or end
  /// with underscore or period, and you cannot have period straight after
  /// underscore, as well as no underscore straight after a period.
  ///
  /// [password] the email to validate
  static bool isValidUsername(String username) {
    final usernameRegex = RegExp(
        r"^[a-zA-Z0-9](_(?!(\.|_))|\.(?!(_|\.))|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]$");
    return usernameRegex.hasMatch(username);
  }

  /// Returns [true] if name is valid, [false] otherwise
  /// All names are valid as long as they arn't empty
  ///
  /// [name] name to validate
  static bool isValidName(String name) {
    return name.isNotEmpty;
  }

  /// Returns [true] if the birthday if valid, [false] otherwise
  ///
  /// [birthday] to validate
  static isValidBirthday(String birthday) {
    final birthdayRegex = RegExp(
        r"^(?:0[1-9]|[12][0-9]|3[01])[-/.](?:0[1-9]|1[012])[-/.](?:19\d{2}|20[01][0-9]|2020)$");
    return birthdayRegex.hasMatch(birthday);
  }

  /// Returns [true] if input is a positive floating decimal, [false] otherwise
  ///
  /// [number] the number to validate
  static isPositiveFloat(String input) {
    num number;
    try {
      number = num.parse(input);
    } catch (e) {
      return false;
    }
    if (number.isNegative) return false;
    return true;
  }
}
