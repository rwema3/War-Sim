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
