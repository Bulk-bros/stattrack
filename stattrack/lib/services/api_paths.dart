class ApiPaths {
  static String user(String uid) => '/users/$uid';

  static String meal(String uid) => '/users/$uid/meals';

  static String log(String uid) => '/users/$uid/log';

  static String storedMeals(String uid) => '/users/$uid/meals';

  static String ingredients(String uid) => '/users/$uid/ingredients';
}
