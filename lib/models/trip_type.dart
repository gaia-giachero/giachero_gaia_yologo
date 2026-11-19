enum TripType {
  backpacking,
  seaAndRelax,
  cityAndCulture,
  onTheRoad,
  natureAndAdventure;

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

  String get searchKeywords {
    switch (this) {
      case TripType.backpacking:
        return 'backpacking travel adventure';
      case TripType.seaAndRelax:
        return 'beach sea relax';
      case TripType.cityAndCulture:
        return 'city landmark architecture';
      case TripType.onTheRoad:
        return 'road trip scenic drive';
      case TripType.natureAndAdventure:
        return 'nature mountains landscape';
    }
  }
}