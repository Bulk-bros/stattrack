class ApiPaths {
  static String users() => '/users';
  static String user(String uid) => '/users/$uid';
  static String profilePicture(String uid) => '$uid/profilepicture';

  static String weights(String uid) => '/users/$uid/weights';

  static String meals(String uid) => '/users/$uid/meals';
  static String meal(String uid, String mealId) => '/users/$uid/meals/$mealId';
  static String mealImage(String uid, String imageId) => '$uid/meals/$imageId';

  static String log(String uid) => '/users/$uid/log';
  static String consumedMeal(String uid, String mealId) =>
      '/users/$uid/log/$mealId';
  static String consumedMealImage(String uid, String imageId) =>
      '$uid/consumedMeals/$imageId';

  static String ingredients(String uid) => '/users/$uid/ingredients';
}
