import 'package:esme2526/datas/user_repository.dart';

import '../models/user.dart';

abstract class UserRepositoryInterface {
  static final UserRepositoryInterface _instance = UserRepository();

  static UserRepositoryInterface get instance => _instance;

  User getUser();
}
