class ApiPaths {
  static String user(String uid) => '/users/$uid';

  static String meal(String uid) => '/users/$uid/meals';

  static String mealImage(String uid, String imageId) => '$uid/meals/$imageId';

  static String log(String uid) => '/users/$uid/log';

  static String storedMeals(String uid) => '/users/$uid/meals';

  static String ingredients(String uid) => '/users/$uid/ingredients';

  static String profilePicture(String uid) => '$uid/profilepicture';
}
