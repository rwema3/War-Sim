// Rules
class Rules {
  // My kid insists there are no extra cards per war, but most rules I've seen
  // seem to suggest it's 3.  More makes games shorter if out of cards during
  // war causes you to lose the war (or game).
  int cardsPerWar;

  // When to shuffle?
  // Shuffle only when you need a card?  Shuffle when your opponent does?
  // Do you shuffle all cards or just the discard pile?
  // Do you never shuffle and just add in the discard pile in a specific order?
  // If so, what is the order of cards put back in your deck?

  // What happens if run out of cards during war? (currently: lose the war).
  // Other options include losing the entire game, or using the last card
  // played as the tie-breaker.

  Rules({this.cardsPerWar = 3});
}

typedef Card = int;

String suit(Card card) {
  return ['Clubs', 'Diamonds', 'Hearts', 'Spades'][card ~/ 13];
}

String rank(Card card) {
  return [
    'Ace',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'Jack',
    'Queen',
    'King'
  ][card % 13];
}

int rankValue(Card card) => card % 13;
String longName(Card card) => '${rank(card)} of ${suit(card)}';
String shortName(Card card) => '${rank(card)[0]}${suit(card)[0]}';
int compare(Card a, Card b) => rankValue(a) - rankValue(b);
bool isSameRank(Card a, Card b) => rankValue(a) == rankValue(b);

class PlayerState {
  final String name;
  final Rules rules;
  List<Card> deck;
  List<Card> discard;
  List<Card> board;

  PlayerState(this.name, this.rules, this.deck, this.discard, this.board);

  List<Card> get playerDeck => deck + discard;

  // Intentionally does not include board.
  int get availableCardCount => deck.length + discard.length;
  bool get hasCards => availableCardCount > 0;

  void shuffleIfNeeded() {
    if (deck.isEmpty) {
      deck = [...discard];
      discard.clear();
      deck.shuffle();
    }
  }

  void playCard() {
    shuffleIfNeeded();
    board.add(deck.removeLast());
  }

  bool playCardIfPossible() {
    if (availableCardCount > 0) {
      playCard();
      return true;
    }
    return false;
  }

  int playCardsIfPossible(int count) {
    int count = 0;
    for (var i = 0; i < count; i++) {
      if (playCardIfPossible()) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  List<Card> takeBoard() {
    var result = [...board];
    board.clear();
    return result;
  }

  Card get lastPlayed => board.last;
}

class Stats {
  int warCount = 0;
  int roundCount = 0;
}

class GameState {
  final Rules rules;
  PlayerState player1;
  PlayerState player2;
  Stats stats;

  GameState(this.rules, this.player1, this.player2, this.stats);

  factory GameState.newGame(Rules rules) {
    var deck = List.generate(52, (i) => i);
    deck.shuffle();
    var half = deck.length ~/ 2;
    return GameState(
        rules,
        PlayerState('p1', rules, deck.sublist(0, half), [], []),
        PlayerState('p2', rules, deck.sublist(half), [], []),
        Stats());
  }
}

void printCardCounts(GameState state) {
  print(
      '${state.player1.name}: ${state.player1.availableCardCount} cards, ${state.player2.name}: ${state.player2.availableCardCount} cards');
}

class Simulator {
  final Rules rules;
  final GameState state;

  Simulator(this.rules, this.state);

  Simulator.newGame(this.rules) : state = GameState.newGame(rules);

  void wonRoundDueToOutOfCards(PlayerState winner) {
    // var loser = winner == state.player1 ? state.player2 : state.player1;
    // print(
    //     '${loser.name}: ran out of cards during war. ${winner.name} wins the war.');
    resolveRound(winner);
  }

  void resolveRound(PlayerState winner) {
    var spoils = [...state.player1.takeBoard(), ...state.player2.takeBoard()];
    winner.discard.addAll(spoils);
  }

  void playRound() {
    var p1 = state.player1;
    var p2 = state.player2;
    bool isWar = false;
    do {
      state.stats.roundCount++;
      // Assuming for now that failure to play a card during war is a loss.
      if (!p1.playCardIfPossible()) {
        return wonRoundDueToOutOfCards(p2);
      }
      if (!p2.playCardIfPossible()) {
        return wonRoundDueToOutOfCards(p1);
      }
