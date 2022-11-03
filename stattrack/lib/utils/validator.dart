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
        RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,20}$");
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
}
