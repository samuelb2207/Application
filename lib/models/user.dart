import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/wallet.dart';

class User {
  final String id;
  final String imgProfilUrl;
  final String name;
  final Wallet wallet;
  final List<Bet> inProgressBets;
  final List<Bet> completedBets;
  final List<Bet> canceledBets;
  final List<Bet> wishlistedBets;

  User({
    required this.id,
    required this.imgProfilUrl,
    required this.name,
    required this.wallet,
    required this.inProgressBets,
    required this.completedBets,
    required this.canceledBets,
    required this.wishlistedBets,
  });
}
