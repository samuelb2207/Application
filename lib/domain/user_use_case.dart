import 'package:esme2526/datas/user_repository_interface.dart';
import 'package:esme2526/models/user.dart';

class UserUseCase {
  final UserRepositoryInterface _userRepository =  UserRepositoryInterface.instance;

  User getUser() => _userRepository.getUser();
}
