import 'package:esme2526/domain/bet_use_case.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/screens/home_page/widgets/bet_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Bet> bets = [];

  @override
  Widget build(BuildContext context) {
    BetUseCase betUseCase = BetUseCase();
    bets.addAll(betUseCase.getBets());

    return ListView.builder(
      itemCount: bets.length,
      itemBuilder: (context, index) {
        final bet = bets[index];
        return BetWidget(bet: bet);
      },
    );
  }
}
