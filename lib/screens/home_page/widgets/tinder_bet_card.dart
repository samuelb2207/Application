import 'dart:math';
import 'package:esme2526/domain/user_bet_case.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TinderBetCard extends StatefulWidget {
  final Bet bet;
  const TinderBetCard({super.key, required this.bet});

  @override
  State<TinderBetCard> createState() => _TinderBetCardState();
}

class _TinderBetCardState extends State<TinderBetCard> {
  Offset _offset = Offset.zero;
  double _angle = 0;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    String videoId = YoutubePlayerController.convertUrlToId(widget.bet.dataBet.videoUrl) ?? '';
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: const YoutubePlayerParams(
        showControls: false,
        mute: true,
        showFullscreenButton: false,
        loop: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
      _angle = _offset.dx / 20;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_offset.dx > 150) {
      _swipe(true); // Right -> Yes
    } else if (_offset.dx < -150) {
      _swipe(false); // Left -> No
    } else {
      setState(() {
        _offset = Offset.zero;
        _angle = 0;
      });
    }
  }

  void _swipe(bool isYes) {
    final choice = isYes ? "Oui" : "Non";
    
    // Place bet logic
    UserBetCase().createUserBet(
      UserBet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: "1", // Hardcoded for now
        betId: widget.bet.id,
        amount: 100, // Default amount
        odds: widget.bet.odds,
        payout: widget.bet.odds * 100,
        createdAt: DateTime.now(),
        choice: choice,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pari "$choice" placé sur: ${widget.bet.title}'),
        duration: const Duration(seconds: 1),
      ),
    );

    setState(() {
      _offset = Offset(isYes ? 500 : -500, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Transform.translate(
          offset: _offset,
          child: Transform.rotate(
            angle: _angle * pi / 180,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    YoutubePlayer(
                      controller: _controller,
                      aspectRatio: 9 / 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bet.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.bet.description,
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildActionIndicator("NON", Colors.red, _offset.dx < -50),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Cote: x${widget.bet.odds}",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              _buildActionIndicator("OUI", Colors.green, _offset.dx > 50),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionIndicator(String label, Color color, bool visible) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: visible ? 1.0 : 0.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
