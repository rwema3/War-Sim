import 'package:stats/stats.dart' as stats_package;
import 'package:war_sim/war_sim.dart';

void printAggregateStatistics(List<Stats> gameStats) {
  void printStats(String label, Iterable<int> values) {
    var stats = stats_package.Stats.fromData(values);
    var rounded = stats.withPrecision(3);
    print("$label: ${rounded.median} (median)");
  }

  printStats("Rounds", gameStats.map((stats) => stats.roundCount));
  printStats("Wars", gameStats.map((stats) => stats.warCount));
}

List<Stats> runSimulations(Rules rules, int count) {
  final gameStats = <Stats>[];
  for (int i = 0; i < count; i++) {
    final sim = Simulator.newGame(rules);
    sim.playGame();
    gameStats.add(sim.state.stats);
  }
  return gameStats;
}

void runSimForRules(Rules rules, String name, {int count = 50000}) {
  print("Simulating with rules \"$name\" N=$count");
  final gameStats = runSimulations(rules, count);
  printAggregateStatistics(gameStats);
}

void main(List<String> arguments) {
  runSimForRules(Rules(cardsPerWar: 1), "Cards per War = 1");
  runSimForRules(Rules(cardsPerWar: 3), "Cards per War = 3");
