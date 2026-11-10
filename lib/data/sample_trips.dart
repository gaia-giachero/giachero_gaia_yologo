import '../models/trip.dart';
import '../models/trip_type.dart';

final List<Trip> sampleTrips = [
  // 1. BARCELLONA
  Trip(
    id: 'trip-1',
    title: 'Nel cuore di Barcellona',
    city: 'Barcellona',
    description: 'Barcellona zaino in spalla: l\'essenza della libertà tra mare, arte e movida. Un viaggio dinamico e low budget alla scoperta della capitale catalana, dove perdersi tra i vicoli del Barrio Gótico, ammirare il genio di Gaudí e godersi un tramonto sulla Barceloneta. Niente valigie pesanti, solo l\'indispensabile sulle spalle per vivere la città a piedi, spostarsi in metro e assaporare la vera cultura locale tra tapas, mercati storici e l\'energia travolgente delle Ramblas.',
    price: '250€',
    departureDate: DateTime.now().add(const Duration(days: 2)),
    returnDate: DateTime.now().add(const Duration(days: 5)),
    type: TripType.cittaCultura,
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  // 2. BARCELLONA
  Trip(
    id: 'trip_2',
    title: 'Relax sulle spiagge di Barcellona',
    city: 'Barcellona',
    description: 'Mare, sole e movida estiva.',
    price: '490.50€',
    departureDate: DateTime.now().add(const Duration(days: 10)),
    returnDate: DateTime.now().add(const Duration(days: 15)),
    type: TripType.mareRelax,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  // 3. Parigi - Test overflow (titolo e descrizione molto lunghi)
  Trip(
    id: 'trip_3',
    title: 'Un tour infinitamente lungo ed esteso attraverso tutta la città di Parigi e i suoi dintorni meravigliosi',
    city: 'Parigi',
    description: 'Descrizione estremamente dettagliata pensata appositamente per verificare che i widget gestiscano l\'overflow del testo con i puntini di sospensione senza mostrare le strisce gialle e nere di errore.',
    price: '899.99€',
    departureDate: DateTime.now().add(const Duration(days: 6)),
    returnDate: DateTime.now().add(const Duration(days: 12)),
    type: TripType.zainoInSpalla,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  // 4. Praga - Viaggio passato
  Trip(
    id: 'trip_4',
    title: 'Magia invernale a Praga',
    city: 'Praga',
    description: 'Passeggiata sul Ponte Carlo al tramonto.',
    price: '280€',
    departureDate: DateTime.now().subtract(const Duration(days: 10)),
    returnDate: DateTime.now().subtract(const Duration(days: 5)),
    type: TripType.cittaCultura,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
  ),
  // 5. Dublino - Oltre i 16 giorni del meteo
  Trip(
    id: 'trip_5',
    title: 'Scogliere e pub a Dublino',
    city: 'Dublino',
    description: 'Avventura on the road tra i paesaggi irlandesi.',
    price: '620€',
    departureDate: DateTime.now().add(const Duration(days: 30)),
    returnDate: DateTime.now().add(const Duration(days: 37)),
    type: TripType.onTheRoad,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];