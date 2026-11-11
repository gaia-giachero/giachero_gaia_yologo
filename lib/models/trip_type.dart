enum TripType {
  backpacking,
  seaAndRelax,
  cityAndCulture,
  onTheRoad,
  natureAndAdventure;

  // Helper per l'etichetta da mostrare a schermo
  String get label {
    switch (this) {
      case TripType.backpacking:
        return 'Zaino in spalla';
      case TripType.seaAndRelax:
        return 'Mare e relax';
      case TripType.cityAndCulture:
        return 'Città e cultura';
      case TripType.onTheRoad:
        return 'On the road';
      case TripType.natureAndAdventure:
        return 'Natura e avventura';
    }
  }
}