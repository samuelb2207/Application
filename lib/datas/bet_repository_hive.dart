import 'package:esme2526/datas/bet_repository_interface.dart';
import 'package:esme2526/models/bet.dart';
import 'package:hive_ce/hive.dart';

class BetRepositoryHive implements BetRepositoryInterface {
  // Store the Future to ensure box is initialized
  final Future<Box<Bet>> _betsBoxFuture;

  // Singleton instance
  static BetRepositoryHive? _instance;

  // Private constructor
  BetRepositoryHive._internal() : _betsBoxFuture = Hive.openBox<Bet>('bets');

  // Helper method to get the box, ensuring it's initialized
  Future<Box<Bet>> get _betsBox => _betsBoxFuture;

  // Factory constructor that returns the singleton instance
  factory BetRepositoryHive() {
    _instance ??= BetRepositoryHive._internal();
    return _instance!;
  }

  @override
  Future<void> saveBets(List<Bet> bets) async {
    final box = await _betsBox;
    // Add new bets without clearing existing ones
    // Use putAll for better performance and to ensure all bets are saved atomically
    final Map<String, Bet> betsMap = {for (var bet in bets) bet.id: bet};
    await box.putAll(betsMap);
  }

  @override
  Future<List<Bet>> getBets() async {
    final box = await _betsBox;
    return box.values.toList();
  }

  @override
  Stream<List<Bet>> getBetsStream() async* {
    final box = await _betsBox;
    // Emit initial list of bets
    final initialBets = box.values.toList();
    yield initialBets;

    // Watch for changes and emit updated list
    // Use asyncMap to ensure we get the box values after each change
    yield* box
        .watch()
        .asyncMap((event) async {
          // Wait a microtask to ensure all pending operations are complete
          await Future.microtask(() {});
          return box.values.toList();
        })
        .distinct((prev, next) {
          // Only emit if the list actually changed
          // Compare by length and IDs to avoid duplicate emissions
          if (prev.length != next.length) return false;
          final prevIds = prev.map((b) => b.id).toSet();
          final nextIds = next.map((b) => b.id).toSet();
          return prevIds.length == nextIds.length && prevIds.every((id) => nextIds.contains(id));
        });
  }
}
