import 'package:esme2526/datas/user_repository.dart';
import 'package:esme2526/domain/user_use_case.dart';
import 'package:esme2526/models/user.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    UserUseCase userUseCase = UserUseCase(UserRepository());
    User user = userUseCase.getUser();

    return Scaffold(
      appBar: AppBar(title: Text("${user.name}")),
      body: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.imgProfilUrl),
                radius: 40,
              ),
              const SizedBox(width: 8),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.account_balance_wallet),
              const SizedBox(width: 8),
              Text(
                "Wallet Balance: ${user.wallet.tokens} tokens",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
