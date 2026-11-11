import '../models/trip.dart';
import '../models/trip_type.dart';

final List<Trip> sampleTrips = [
  // 1. BARCELLONA
  Trip(
    id: 'trip_1',
    title: 'Nel cuore di Barcellona',
    city: 'Barcellona',
    description: 'Barcellona zaino in spalla: l\'essenza della libertà tra mare, arte e movida. Un viaggio dinamico e low budget alla scoperta della capitale catalana, dove perdersi tra i vicoli del Barrio Gótico, ammirare il genio di Gaudí e godersi un tramonto sulla Barceloneta. Niente valigie pesanti, solo l\'indispensabile sulle spalle per vivere la città a piedi, spostarsi in metro e assaporare la vera cultura locale tra tapas, mercati storici e l\'energia travolgente delle Ramblas.',
    price: 250,
    departureDate: DateTime.now().add(const Duration(days: 2)),
    returnDate: DateTime.now().add(const Duration(days: 5)),
    type: TripType.cityAndCulture,
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  
  // 2. BARCELLONA
  Trip(
    id: 'trip_2',
    title: 'Relax sulle spiagge di Barcellona',
    city: 'Barcellona',
    description: 'Mare, sole e movida estiva.',
    price: 490.50,
    departureDate: DateTime.now().add(const Duration(days: 10)),
    returnDate: DateTime.now().add(const Duration(days: 15)),
    type: TripType.seaAndRelax,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),

  // 3. PARIGI
  Trip(
    id: 'trip_3',
    title: 'Un tour infinitamente lungo ed esteso attraverso tutta la città di Parigi e i suoi dintorni meravigliosi',
    city: 'Parigi',
    description: 'Descrizione estremamente dettagliata pensata appositamente per verificare che i widget gestiscano l\'overflow del testo con i puntini di sospensione senza mostrare le strisce gialle e nere di errore.',
    price: 899.99,
    departureDate: DateTime.now().add(const Duration(days: 6)),
    returnDate: DateTime.now().add(const Duration(days: 12)),
    type: TripType.backpacking,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),

  // 4. PRAGA
  Trip(
    id: 'trip_4',
    title: 'Magia invernale a Praga',
    city: 'Praga',
    description: 'Passeggiata sul Ponte Carlo al tramonto.',
    price: 280,
    departureDate: DateTime.now().subtract(const Duration(days: 10)),
    returnDate: DateTime.now().subtract(const Duration(days: 5)),
    type: TripType.cityAndCulture,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
  ),

  // 5. DUBLINO
  Trip(
    id: 'trip_5',
    title: 'Scogliere e pub a Dublino',
    city: 'Dublino',
    description: 'Avventura on the road tra i paesaggi irlandesi.',
    price: 620,
    departureDate: DateTime.now().add(const Duration(days: 30)),
    returnDate: DateTime.now().add(const Duration(days: 37)),
    type: TripType.onTheRoad,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),

  // 6. BUDAPEST
  Trip(
    id: 'trip_6',
    title: 'I segreti del Danubio: Budapest',
    city: 'Budapest',
    description: 'Un affascinante viaggio tra i ponti storici del Danubio, il maestoso Parlamento e il relax dei rinomati bagni termali Széchenyi.',
    price: 190.00,
    departureDate: DateTime(2026, 12, 2),
    returnDate: DateTime(2026, 12, 5),
    type: TripType.cityAndCulture,
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),

  // 7. ATENE
  Trip(
    id: 'trip_7',
    title: 'Miti e leggende ad Atene',
    city: 'Atene',
    description: 'Immersione nella storia antica tra l\'imponente Acropoli, le rovine dell\'Agora e le passeggiate tra le viuzze tradizionali di Plaka.',
    price: 340.00,
    departureDate: DateTime.now().add(const Duration(days: 14)),
    returnDate: DateTime.now().add(const Duration(days: 18)),
    type: TripType.cityAndCulture,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),

  // 8. ROMA
  Trip(
    id: 'trip_8',
    title: 'La Citta Eterna tra storia e cucina',
    city: 'Roma',
    description: 'Weekend romantico e culturale tra il Colosseo, Fontana di Trevi e le autentiche osterie di Trastevere.',
    price: 220.50,
    departureDate: DateTime.now().add(const Duration(days: 8)),
    returnDate: DateTime.now().add(const Duration(days: 11)),
    type: TripType.seaAndRelax,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),

  // 9. LISBONA
  Trip(
    id: 'trip_9',
    title: 'Scorci e Fado a Lisbona',
    city: 'Lisbona',
    description: 'Tour dinamico su e giu per i sette colli della capitale portoghese a bordo dello storico Tram 28 e vista sull\'Oceano da Belém.',
    price: 410.00,
    departureDate: DateTime.now().add(const Duration(days: 22)),
    returnDate: DateTime.now().add(const Duration(days: 27)),
    type: TripType.backpacking,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),

  // 10. REYKJAVIK
  Trip(
    id: 'trip_10',
    title: 'Caccia all\'Aurora e Geyser a Reykjavik',
    city: 'Reykjavik',
    description: 'Spedizioni selvagge e panorami mozzafiato tra cascate congelate, spiagge nere e sorgenti termali naturali.',
    price: 780.00,
    departureDate: DateTime.now().add(const Duration(days: 40)),
    returnDate: DateTime.now().add(const Duration(days: 47)),
    type: TripType.onTheRoad,
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
];