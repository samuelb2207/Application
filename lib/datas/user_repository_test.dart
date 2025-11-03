import 'package:esme2526/datas/user_repository_interface.dart';
import 'package:esme2526/models/user.dart';
import 'package:esme2526/models/wallet.dart';

class UserRepositoryTest implements UserRepositoryInterface{
  @override
  User getUser() {
    return User(
      id: "test",
      imgProfilUrl:
          "https://assets.codepen.io/1477099/internal/avatars/users/default.png",
      name: "Jane Doe",
      wallet: Wallet(id: "test", tokens: 100),
      inProgressBets: [],
      completedBets: [],
      canceledBets: [],
      wishlistedBets: [],
    );
  
  }
}
