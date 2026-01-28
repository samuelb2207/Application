class UserBet {
  final String id;
  final String userId;
  final String betId;
  final int amount;
  final double odds;
  final double payout;
  final DateTime createdAt;
  final String choice; // "Oui" or "Non"

  UserBet({
    required this.id,
    required this.userId,
    required this.betId,
    required this.amount,
    required this.odds,
    required this.payout,
    required this.createdAt,
    required this.choice,
  });
}
