enum TripType {
  zainoInSpalla,
  mareRelax,
  cittaCultura,
  onTheRoad,
  naturaAvventura;

  // Helper per l'etichetta da mostrare a schermo
  String get label {
    switch (this) {
      case TripType.zainoInSpalla:
        return 'Zaino in spalla';
      case TripType.mareRelax:
        return 'Mare e relax';
      case TripType.cittaCultura:
        return 'Città e cultura';
      case TripType.onTheRoad:
        return 'On the road';
      case TripType.naturaAvventura:
        return 'Natura e avventura';
    }
  }
}