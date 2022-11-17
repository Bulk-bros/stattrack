import 'package:image_picker/image_picker.dart';
import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/models/user.dart';

abstract class Repository {
  /// Returns a stream with the user that has the user id specified
  /// If no user is found with the given id, a stream of null is returned
  ///
  /// [uid] the user id of the user to find
  Stream<User?> getUsers(String uid);

  /// Adds a user to the database
  ///
  /// [user] the user to add
  /// [uid] the id of the user to add
  void addUser(User user, String uid);

  /// Returns a stream with the consumed meals of the user with the given id
  ///
  /// [uid] the user id of the user to find the consumed meals of
  Stream<List<ConsumedMeal>> getLog(String uid);


  Stream<List<ConsumedMeal>> getTodaysMeals(String uid);

  /// Uploads a profile picture to the cloud
  ///
  /// [image] the image to upload
  /// [uid] the id of the user to upload the image for
  Future<void> uploadProfilePicture(XFile image, String uid);

  /// Returns the url for the profile picture of the user with the given
  /// user id
  ///
  /// [uid] the user id to get the profile picture url for
  Future<String?> getProfilePictureUrl(String uid);

}
