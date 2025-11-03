import 'package:esme2526/models/user.dart';
import 'package:esme2526/models/wallet.dart';

class UserRepository {
  User getUser() {
    return User(
      id: "1",
      imgProfilUrl:
          "https://assets.codepen.io/1477099/internal/avatars/users/default.png",
      name: "John Doe",
      wallet: Wallet(id: "1", tokens: 100),
      inProgressBets: [],
      completedBets: [],
      canceledBets: [],
      wishlistedBets: [],
    );
  }
}
