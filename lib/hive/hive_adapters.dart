import 'package:esme2526/models/data_bet.dart';
import 'package:hive_ce/hive.dart';
import '../models/bet.dart';

@GenerateAdapters([AdapterSpec<Bet>(), AdapterSpec<DataBet>()])
part 'hive_adapters.g.dart';
