import 'package:esme2526/models/bet.dart';
import 'package:esme2526/screens/bet_page.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BetWidget extends StatefulWidget {
  final Bet bet;

  const BetWidget({super.key, required this.bet});

  @override
  State<BetWidget> createState() => _BetWidgetState();
}

class _BetWidgetState extends State<BetWidget> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    String videoId = YoutubePlayerController.convertUrlToId(widget.bet.dataBet.videoUrl) ?? '';

    controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: false,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );

    // Ensure the video doesn't auto-play by seeking to the beginning without playing
    // The YouTube player will show as paused initially but with controls visible
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BetPage(bet: widget.bet, textEditingController: TextEditingController()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Section
            Flexible(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(controller: controller, aspectRatio: 16 / 9),
                ),
              ),
            ),

            // Content Section
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Flexible(
                      child: Text(
                        widget.bet.title,
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Description
                    Flexible(
                      child: Text(
                        widget.bet.description,
                        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E88E5), // Winamax blue
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'x${widget.bet.odds.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),

                        Flexible(
                          child: FilledButton(
                            onPressed: () {
                              // Alert dialog to place a bet
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Place Bet'),
                                    content: const Text('Are you sure you want to place this bet?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bet placed successfully!')));
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text("Place Bet"),
                          ),
                        ),

                        // Time indicator
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                            decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(6.0)),
                            child: Text(
                              'Starts: ${_formatDateTime(widget.bet.startTime)}',
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.orange.shade800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
