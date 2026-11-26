# YoloGo

App Flutter per scoprire e proporre viaggi last-minute. Ogni utente può esplorare le proposte degli altri, salvarle tra i preferiti e creare i propri viaggi. Progetto finale del corso Flutter & Dart.

## Funzionalità

- Login con Supabase Auth e splash screen animata (globo con aereo) durante l'avvio
- **Home**: destinazioni popolari (le più presenti nel database) che aprono Esplora già filtrato
- **Esplora**: ricerca per testo, prezzo massimo e tipologia di viaggio
- **Dettaglio**: informazioni sul paese e meteo previsto per le date del viaggio
- **Crea / modifica / elimina** un viaggio con form validato (solo il proprietario può modificarlo o eliminarlo)
- **Preferiti**: lista dei viaggi aggiunti ai preferiti
- **Profilo**: impostazioni e lista dei viaggi creati
- **Impostazioni**: tema chiaro/scuro salvato con SharedPreferences

## API e servizi usati

| Servizio | Endpoint | Uso |
|---|---|---|
| Unsplash | `api.unsplash.com/search/photos` | immagine di copertina per città |
| Open-Meteo Geocoding | `geocoding-api.open-meteo.com/v1/search` | coordinate e codice paese della città |
| Open-Meteo Forecast | `api.open-meteo.com/v1/forecast` | previsioni giornaliere per le date del viaggio |
| REST Countries | `www.apicountries.com/alpha/{codice}` | dati del paese (lingua, valuta, ...) |
| Supabase | tabelle `trips`, `favorites`, `profiles`, `popular_destinations` | autenticazione e dati dell'app |

Le chiamate HTTP usano il pacchetto `http`. Loading, errore e "riprova" sono gestiti nei flussi di rete (lista Esplora, Home, Preferiti, Profilo, Dettaglio).

## Configurazione

1. `flutter pub get`
2. Copia ogni file `lib/config/*.example.dart` nel corrispondente `*.dart` (senza `.example`) e inserisci le tue chiavi:
   - `supabase_config.dart`: URL e chiave pubblica del progetto Supabase
   - `unsplash_config.dart`: access key di Unsplash
3. `flutter run`

I file di configurazione con le chiavi reali non vanno committati.

## Note

- Gestione dello stato con `setState`; i preferiti sono centralizzati nella schermata principale e passati alle schermate figlie.
- Le risposte di Unsplash, paese e meteo sono messe in cache per rispettare i limiti delle API gratuite (Unsplash circa 50 richieste all'ora in modalità demo).
- Il meteo è disponibile solo per le date entro il limite di previsione di Open-Meteo.