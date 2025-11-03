import 'package:esme2526/datas/bet_repository_interface.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/data_bet.dart';

class BetRepository implements BetRepositoryInterface {

  @override
  List<Bet> getBets() {
    return [
      Bet(
        id: "1",
        title: "Match de Football - Coupe du Monde",
        description: "Parier sur le vainqueur du match France vs Brésil",
        odds: 2,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 2)),
        dataBet: DataBet(id: "1", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "2",
        title: "Tennis - Finale Roland Garros",
        description: "Qui remportera le titre cette année?",
        odds: 3,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 3)),
        dataBet: DataBet(id: "2", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "3",
        title: "Basket - NBA Finals",
        description: "Prédire le score final de la série",
        odds: 4,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 4)),
        dataBet: DataBet(id: "3", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "4",
        title: "Formule 1 - Grand Prix de Monaco",
        description: "Quel pilote obtiendra la pole position?",
        odds: 5,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        dataBet: DataBet(id: "4", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "5",
        title: "Rugby - Tournoi des 6 Nations",
        description: "Parier sur l'équipe qui remportera le tournoi",
        odds: 6,
        startTime: DateTime.now().add(Duration(hours: 1)),
        endTime: DateTime.now().add(Duration(hours: 5)),
        dataBet: DataBet(id: "5", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "6",
        title: "E-sport - Championnat League of Legends",
        description: "Quelle équipe remportera la finale?",
        odds: 7,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 6)),
        dataBet: DataBet(id: "6", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "7",
        title: "Hockey - Ligue Nationale",
        description: "Prédire le nombre de buts dans le match",
        odds: 3,
        startTime: DateTime.now().add(Duration(hours: 2)),
        endTime: DateTime.now().add(Duration(hours: 4)),
        dataBet: DataBet(id: "7", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "8",
        title: "Boxe - Combat du Siècle",
        description: "Qui gagnera par KO dans les 5 premiers rounds?",
        odds: 8,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 3)),
        dataBet: DataBet(id: "8", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "9",
        title: "Golf - Masters Tournament",
        description: "Quel golfeur terminera avec le meilleur score?",
        odds: 5,
        startTime: DateTime.now().add(Duration(hours: 1)),
        endTime: DateTime.now().add(Duration(hours: 7)),
        dataBet: DataBet(id: "9", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
      Bet(
        id: "10",
        title: "Natation - Championnats du Monde",
        description: "Prédire le temps du record du monde du 100m nage libre",
        odds: 10,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 2)),
        dataBet: DataBet(id: "10", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", imgUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      ),
    ];
  }

}