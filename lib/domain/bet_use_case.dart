import 'package:esme2526/datas/bet_repository_interface.dart';
import 'package:esme2526/models/bet.dart';

class BetUseCase {
  final BetRepositoryInterface _repository = BetRepositoryInterface.instance;

  List<Bet> getBets() {
    return _repository.getBets();
  }
}
