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