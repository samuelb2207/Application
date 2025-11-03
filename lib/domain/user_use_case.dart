import 'package:esme2526/datas/user_repository.dart';
import 'package:esme2526/models/user.dart';

class UserUseCase {
  final UserRepository _userRepository;

  UserUseCase(this._userRepository);

  User getUser() {
    return _userRepository.getUser();
  }
}
