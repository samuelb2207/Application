import 'package:esme2526/models/user.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final User user;

  const ProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(user.imgProfilUrl), radius: 40),
            const SizedBox(width: 8),
            Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.account_balance_wallet),
            const SizedBox(width: 8),
            Text("Wallet Balance: ${user.wallet.tokens} tokens", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }
}
