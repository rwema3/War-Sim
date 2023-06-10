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
