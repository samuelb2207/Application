import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart' as api; // Alias pour éviter conflit
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// ================= COULEURS DU THÈME =================
const Color kPrimaryBlue = Color(0xFF1565C0);
const Color kAccentOrange = Color(0xFFFF6F00);
const Color kBackgroundLight = Color(0xFFF5F7FA);
const Color kCardWhite = Colors.white;
const Color kTextDark = Color(0xFF263238);
const Color kGreenYes = Color(0xFF00C853);
const Color kRedNo = Color(0xFFD50000);
// =====================================================

void main() => runApp(MaterialApp(
  home: const PolyBetAppV5(),
  debugShowCheckedModeBanner: false,
  themeMode: ThemeMode.light,
  theme: ThemeData(
    brightness: Brightness.light,
    primaryColor: kPrimaryBlue,
    scaffoldBackgroundColor: kBackgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: kCardWhite,
      foregroundColor: kTextDark,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: kPrimaryBlue),
      titleTextStyle: TextStyle(color: kTextDark, fontWeight: FontWeight.bold, fontSize: 20),
    ),
  ),
));

class PolyBetAppV5 extends StatefulWidget {
  const PolyBetAppV5({super.key});
  @override
  State<PolyBetAppV5> createState() => _PolyBetAppV5State();
}

class _PolyBetAppV5State extends State<PolyBetAppV5> {
  int coins = 1000;
  final int fixedWager = 50;

  String _userName = "Challenger";
  String _userAvatar = "https://loremflickr.com/200/200/business,man";

  List<Map<String, dynamic>> history = [];
  late List<Map<String, dynamic>> availableParis;
  HttpServer? _server; // Le serveur web local

  final List<Map<String, dynamic>> _allParis = [
    {
      "id": "s1", "cat": "SPORT", "q": "Mbappé buteur ce soir ?", "desc": "Ligue des Champions.",
      "img": "https://loremflickr.com/800/600/stadium,soccer", "chanceOui": 65,
      "stats": {"Forme": "Top", "Tirs": "5/m"}, "expert": "Défense adverse fébrile.", "chart": [20, 50, 40, 80, 65]
    },
    {
      "id": "f1", "cat": "FINANCE", "q": "Bitcoin > 100k\$ ?", "desc": "Semaine décisive.",
      "img": "https://loremflickr.com/800/600/bitcoin,trading", "chanceOui": 42,
      "stats": {"RSI": "Surachat"}, "expert": "Grosse résistance technique.", "chart": [30, 40, 60, 50, 42]
    },
    {
      "id": "t1", "cat": "TECH", "q": "L'IA remplace les devs ?", "desc": "D'ici 5 ans.",
      "img": "https://loremflickr.com/800/600/code,robot", "chanceOui": 20,
      "stats": {"Progrès": "Rapide"}, "expert": "Elle assistera, ne remplacera pas.", "chart": [5, 10, 15, 25, 20]
    },
    {
      "id": "m1", "cat": "CLIMAT", "q": "Canicule cet été ?", "desc": "Records attendus.",
      "img": "https://loremflickr.com/800/600/sun,desert", "chanceOui": 85,
      "stats": {"CO2": "Max"}, "expert": "Préparez la climatisation.", "chart": [60, 70, 80, 85, 85]
    },
    {
      "id": "p1", "cat": "PEOPLE", "q": "Retour de Rihanna ?", "desc": "Nouvel album ?",
      "img": "https://loremflickr.com/800/600/concert,mic", "chanceOui": 30,
      "stats": {"Rumeur": "Forte"}, "expert": "Sa marque Fenty est sa priorité.", "chart": [50, 40, 30, 30, 30]
    },
  ];

  @override
  void initState() {
    super.initState();
    availableParis = List.from(_allParis)..shuffle();
    _requestPermissions();
    _sendToArduino(coins);
  }

  Future<void> _requestPermissions() async {
    await [Permission.location, Permission.nearbyWifiDevices].request();
  }

  void _sendToArduino(int value) async {
    try {
      final socket = await Socket.connect('10.0.2.2', 4545, timeout: const Duration(milliseconds: 500));
      socket.write('$value');
      await socket.flush();
      socket.close();
    } catch (e) { }
  }

  double getOdd(int percentage) {
    if (percentage <= 0) return 99.0;
    if (percentage >= 100) return 1.01;
    return double.parse((100 / percentage).toStringAsFixed(2));
  }

  // --- 1. LOGIQUE DE PARI ---
  void _executeBet(int index, bool isOui) {
    HapticFeedback.heavyImpact();

    int chanceOui = (availableParis[index]['chanceOui'] as num).toInt();
    bool resultatReelEstOui = Random().nextInt(100) < chanceOui;
    bool isWin = (isOui && resultatReelEstOui) || (!isOui && !resultatReelEstOui);

    int mise = fixedWager;
    double coteJouee = isOui ? getOdd(chanceOui) : getOdd(100 - chanceOui);
    int gainTotal = (mise * coteJouee).round();
    int profitNet = gainTotal - mise;

    setState(() {
      if (isWin) { coins += profitNet; } else { coins -= mise; }
      history.insert(0, {
        "q": availableParis[index]['q'],
        "choix": isOui ? "OUI (x$coteJouee)" : "NON (x$coteJouee)",
        "resultat": isWin ? "GAGNÉ" : "PERDU",
        "gain": isWin ? "+$profitNet" : "-$mise",
        "img": availableParis[index]['img']
      });
      availableParis.removeAt(index);
    });

    _sendToArduino(coins);
  }

  // --- 2. LE SERVEUR ET LE QR CODE ---
  Future<bool?> _startServerAndShowQR(Map<String, dynamic> pari, bool isOui) async {
    final info = NetworkInfo();
    var wifiIP = await info.getWifiIP();

    if (wifiIP == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⚠️ Connectez-vous au Wifi pour valider !")));
      return false;
    }

    Completer<bool> validationCompleter = Completer();
    var app = api.Router();

    // -- LA PAGE WEB VUE PAR LE TELEPHONE 2 --
    app.get('/valider', (shelf.Request request) {
      if (!validationCompleter.isCompleted) {
        validationCompleter.complete(true); // Validation réussie
      }

      // HTML demandé par le Grand Monarque
      return shelf.Response.ok("""
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { font-family: sans-serif; text-align: center; background-color: #1565C0; color: white; padding: 50px 20px; }
            .card { background: white; color: #333; padding: 30px; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.2); }
            h1 { color: #1565C0; }
            .check { font-size: 80px; color: #00C853; margin: 20px 0; }
          </style>
        </head>
        <body>
          <div class="card">
            <h1>Pari validé</h1>
            <div class="check">✔</div>
            <p style="font-size: 18px; font-weight: bold;">Veuillez regarder votre application</p>
          </div>
        </body>
        </html>
      """, headers: {'content-type': 'text/html'});
    });

    var handler = const shelf.Pipeline().addMiddleware(shelf.logRequests()).addHandler(app.call);

    // Essai port 8080 ou 8081
    try { _server = await io.serve(handler, InternetAddress.anyIPv4, 8080); }
    catch (e) { _server = await io.serve(handler, InternetAddress.anyIPv4, 8081); }

    String validationUrl = "http://$wifiIP:${_server!.port}/valider";

    // Affichage QR Code
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text("Scan Requis", textAlign: TextAlign.center, style: TextStyle(color: kTextDark, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 220, width: 220,
              child: QrImageView(data: validationUrl, size: 220),
            ),
            const SizedBox(height: 15),
            const Text("En attente du scan...", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            const LinearProgressIndicator(color: kPrimaryBlue, backgroundColor: kBackgroundLight),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
            _server?.close(force: true);
            if (!validationCompleter.isCompleted) validationCompleter.complete(false);
            Navigator.pop(ctx);
          }, child: const Text("ANNULER", style: TextStyle(color: Colors.grey)))
        ],
      ),
    );

    // Attente...
    bool result = await validationCompleter.future;

    // Fermeture propre
    await _server?.close(force: true);
    if (mounted) Navigator.pop(context); // Ferme le QR Code

    return result;
  }

  // --- 3. AFFICHAGE "VALIDÉ" SUR TELEPHONE 1 ---
  Future<void> _showSuccessDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        // Fermeture automatique après 2 secondes
        Future.delayed(const Duration(seconds: 2), () {
          if (ctx.mounted) Navigator.of(ctx).pop();
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.transparent, // Fond transparent pour effet visuel
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5)]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: kGreenYes.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, color: kGreenYes, size: 80),
                ),
                const SizedBox(height: 20),
                const Text("PARI VALIDÉ", style: TextStyle(color: kTextDark, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                const SizedBox(height: 10),
                const Text("Le sort en est jeté !", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- RESET ---
  void _resetApp() {
    setState(() {
      coins = 1000;
      history.clear();
      availableParis = List.from(_allParis)..shuffle();
    });
    _sendToArduino(1000);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- INTERFACE V3 CONSERVÉE ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: kPrimaryBlue),
              accountName: Text(_userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Text("Solde : $coins Coins"),
              currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage(_userAvatar)),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: kPrimaryBlue),
              title: const Text("Historique"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen(history: history)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: kPrimaryBlue),
              title: const Text("Profil & Stats"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userName: _userName, userAvatar: _userAvatar, coins: coins, historyCount: history.length, onReset: _resetApp)));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("PolyBet Ultimate"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: kPrimaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const Icon(Icons.monetization_on, color: kAccentOrange, size: 20),
              const SizedBox(width: 5),
              Text("$coins", style: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: availableParis.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 80, color: kPrimaryBlue.withOpacity(0.5)),
                  const SizedBox(height: 20),
                  const Text("Plus de paris !", style: TextStyle(color: kTextDark, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue, foregroundColor: Colors.white),
                      onPressed: () => setState(() => availableParis = List.from(_allParis)..shuffle()),
                      icon: const Icon(Icons.replay), label: const Text("Recharger")
                  )
                ],
              ),
            )
                : PageView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              controller: PageController(viewportFraction: 0.90),
              itemCount: availableParis.length,
              itemBuilder: (context, index) {
                final pari = availableParis[index];
                return Center(
                  child: Dismissible(
                    key: Key(pari['id']),
                    confirmDismiss: (direction) async {
                      bool isOui = direction == DismissDirection.startToEnd;

                      // 1. Lance le serveur et attend le scan
                      bool? validated = await _startServerAndShowQR(pari, isOui);

                      if (validated == true) {
                        // 2. Scan réussi -> Affiche la grosse popup "PARI VALIDÉ"
                        await _showSuccessDialog();

                        // 3. Exécute le pari (gain/perte)
                        _executeBet(index, isOui);
                        return true; // La carte disparait
                      }
                      return false; // Annulé
                    },
                    background: _buildSwipeBackground(true),
                    secondaryBackground: _buildSwipeBackground(false),
                    child: _buildBubbleBetCard(pari),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Mise fixe : $fixedWager Coins", style: TextStyle(color: kTextDark.withOpacity(0.4), fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildSwipeBackground(bool isOui) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isOui ? kGreenYes : kRedNo,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Align(
        alignment: isOui ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Icon(isOui ? Icons.thumb_up_alt : Icons.thumb_down_alt, size: 60, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBubbleBetCard(Map<String, dynamic> pari) {
    int chance = (pari['chanceOui'] as num).toInt();
    double coteOui = getOdd(chance);
    double coteNon = getOdd(100 - chance);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: kCardWhite,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(pari['img'], height: 250, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (c,e,s) => Container(height: 250, color: Colors.grey[300])),
              Positioned(
                top: 15, left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.circular(20)),
                  child: Text(pari['cat'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(pari['q'], textAlign: TextAlign.center, style: const TextStyle(color: kTextDark, fontSize: 24, fontWeight: FontWeight.w800, height: 1.1)),
                      const SizedBox(height: 8),
                      Text(pari['desc'], style: TextStyle(color: kTextDark.withOpacity(0.6), fontSize: 16)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBubble(chance, coteOui, true),
                      const Text("VS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      _buildBubble(100 - chance, coteNon, false),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(int percentage, double cote, bool isOui) {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: isOui ? kGreenYes : kRedNo, shape: BoxShape.circle, boxShadow: [BoxShadow(color: (isOui ? kGreenYes : kRedNo).withOpacity(0.4), blurRadius: 10, offset: const Offset(0,4))]),
          child: Center(child: Text("$percentage%", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 10),
        Text(isOui ? "OUI" : "NON", style: TextStyle(color: isOui ? kGreenYes : kRedNo, fontWeight: FontWeight.w900, fontSize: 16)),
        Text("x$cote", style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// --- PAGE HISTORIQUE ---
class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  const HistoryScreen({super.key, required this.history});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historique")),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(labelColor: kGreenYes, unselectedLabelColor: Colors.grey, indicatorColor: kGreenYes, tabs: [Tab(text: "GAGNÉS"), Tab(text: "PERDUS")]),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(history.where((e) => e['resultat'] == "GAGNÉ").toList()),
                  _buildList(history.where((e) => e['resultat'] == "PERDU").toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return const Center(child: Text("Aucun pari ici."));
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        bool isGain = item['gain'].contains('+');
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(item['img'])),
            title: Text(item['q'], maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(item['resultat'], style: TextStyle(color: isGain ? kGreenYes : kRedNo, fontWeight: FontWeight.bold)),
            trailing: Text(item['gain'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isGain ? kGreenYes : kRedNo)),
          ),
        );
      },
    );
  }
}

// --- PAGE PROFIL ---
class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final int coins;
  final int historyCount;
  final VoidCallback onReset;

  const ProfileScreen({super.key, required this.userName, required this.userAvatar, required this.coins, required this.historyCount, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 60, backgroundImage: NetworkImage(userAvatar)),
            const SizedBox(height: 20),
            Text(userName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kTextDark)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _stat("Solde", "$coins", kPrimaryBlue),
                const SizedBox(width: 40),
                _stat("Paris", "$historyCount", kAccentOrange),
              ],
            ),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              onPressed: onReset,
              icon: const Icon(Icons.delete_forever),
              label: const Text("RÉINITIALISER TOUT"),
            )
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}