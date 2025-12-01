import 'package:esme2526/datas/bet_repository_hive.dart';
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
  Widget build(BuildContext context) {
    return StreamBuilder<List<Bet>>(
      stream: BetRepositoryHive().getBetsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          List<Bet> bets = snapshot.data ?? [];
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9, // Adjust to your layout
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: bets.length,
            itemBuilder: (context, index) {
              return BetWidget(bet: bets[index]);
            },
          );
        }

        return Center(child: Text('No Data'));
      },
    );
  }
}
