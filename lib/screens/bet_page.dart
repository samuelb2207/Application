import 'package:esme2526/models/bet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BetPage extends StatelessWidget {
  final Bet bet;
  TextEditingController textEditingController;

  BetPage({super.key, required this.bet, required this.textEditingController}) {
    textEditingController.text = "100";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bet.title)),
      body: Column(
        children: [
          Text(bet.description),
          Text("Odds: ${bet.odds}"),
          SizedBox(height: 10),
          TextField(
            controller: textEditingController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Enter your bet"),
          ),
          SizedBox(height: 10),
          FilledButton(
            onPressed: () async {
              bool? result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Place Bet"),
                  content: Text("Gain potential: ${bet.odds * int.parse(textEditingController.text)}"),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text("Cancel")),
                    TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text("Confirm")),
                  ],
                ),
              );
              if (result == true) {
                Navigator.of(context).pop();
              } else {
                print("Bet not placed");
              }
            },
            child: Text("Place Bet"),
          ),
        ],
      ),
    );
  }
}
