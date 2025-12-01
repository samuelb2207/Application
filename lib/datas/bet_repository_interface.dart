import 'package:esme2526/datas/bet_repository.dart';
import 'package:esme2526/models/bet.dart';

abstract class BetRepositoryInterface {
  static final BetRepositoryInterface _instance = BetRepository();
  static BetRepositoryInterface get instance => _instance;

  Future<List<Bet>> getBets();
  Stream<List<Bet>> getBetsStream();
  Future<void> saveBets(List<Bet> bets);
}
