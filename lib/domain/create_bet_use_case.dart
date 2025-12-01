import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/models/bet.dart';

class CreateBetUseCase {
  Future<void> createBet(Bet bet) async {
    final betWithId = Bet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: bet.title,
      description: bet.description,
      odds: bet.odds,
      startTime: bet.startTime,
      endTime: bet.endTime,
      dataBet: bet.dataBet,
    );
    await BetRepositoryHive().saveBets([betWithId]);
  }
}
