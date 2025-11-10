import 'package:esme2526/models/data_bet.dart';

class Bet {
  final String id;
  final String title;
  final String description;
  final double odds;
  final DateTime startTime;
  final DateTime endTime;
  final DataBet dataBet;

  Bet({
    required this.id,
    required this.title,
    required this.description,
    required this.odds,
    required this.startTime,
    required this.endTime,
    required this.dataBet,
  });
}
