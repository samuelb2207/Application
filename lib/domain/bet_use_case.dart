import 'package:esme2526/datas/bet_repository_interface.dart';
import 'package:esme2526/models/bet.dart';

class BetUseCase {
  final BetRepositoryInterface _repository = BetRepositoryInterface.instance;

  Future<List<Bet>> getBets() async {
    return await _repository.getBets();
  }

  Stream<List<Bet>> getBetsStream() {
    return _repository.getBetsStream();
  }
}
