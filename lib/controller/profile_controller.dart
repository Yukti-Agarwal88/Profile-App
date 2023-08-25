import 'package:get/get.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:profile_app/repository/user_repo.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _userRepo = Get.put(UserRepo());

  Future<List<UserModel>> getAllUserData() async {
    return await _userRepo.allUser();
  }
}
