import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/screens/home_page/widgets/tinder_bet_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Bet>>(
      stream: BetRepositoryHive().getBetsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          List<Bet> bets = snapshot.data!;
          return PageView.builder(
            scrollDirection: Axis.vertical, // TikTok style vertical scroll
            controller: _pageController,
            itemCount: bets.length,
            itemBuilder: (context, index) {
              return TinderBetCard(bet: bets[index]);
            },
          );
        }

        return const Center(child: Text('No Data'));
      },
    );
  }
}
