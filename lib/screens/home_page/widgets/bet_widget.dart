import 'package:esme2526/models/bet.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BetWidget extends StatelessWidget {
  final Bet bet;
  final YoutubePlayerController controller = YoutubePlayerController(
    params: YoutubePlayerParams(
      showControls: true,
      showFullscreenButton: true,
      origin: 'https://www.youtube-nocookie.com',
    ),
  );

  BetWidget({super.key, required this.bet}) {
    String videoId =
        YoutubePlayerController.convertUrlToId(bet.dataBet.videoUrl) ?? '';
    controller.loadVideoById(videoId: videoId);
  }

  @override
  Widget build(BuildContext context) {
    //return ListTile(
    //  title: Text('Bet on ${bet.title}'),
    //  subtitle: Text('Odd: \$${bet.odds}'),
    //  trailing: Icon(Icons.arrow_forward),
    //);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: YoutubePlayer(controller: controller),
          ),
          SizedBox(height: 8),
          Text(
            bet.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(bet.description),
          SizedBox(height: 4),
          Text(
            'Odds: ${bet.odds.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Divider(),
        ],
      ),
    );
  }
}
