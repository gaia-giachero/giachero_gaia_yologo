# YoloGo

A Flutter app to discover and share last-minute trips. Every user can look at other people's trips, save them as favorites, and create their own trips. Final project of the Flutter & Dart course.

## Features

- Login with Supabase Auth and an animated splash screen (a globe with a plane) while the app starts
- **Home**: popular destinations (the ones that appear most in the database) that open Explore already filtered
- **Explore**: search by text, maximum price, and type of trip
- **Details**: information about the country and the weather forecast for the trip dates
- **Create / edit / delete** a trip with a validated form (only the owner can edit or delete it)
- **Favorites**: list of the trips added to favorites
- **Profile**: settings and list of the trips you created
- **Settings**: light/dark theme saved with SharedPreferences

## APIs and services used

| Service              | Endpoint                                                        | Use                                      |
| -------------------- | --------------------------------------------------------------- | ---------------------------------------- |
| Unsplash             | `api.unsplash.com/search/photos`                                | cover image for each city                |
| Open-Meteo Geocoding | `geocoding-api.open-meteo.com/v1/search`                        | coordinates and country code of the city |
| Open-Meteo Forecast  | `api.open-meteo.com/v1/forecast`                                | daily forecast for the trip dates        |
| REST Countries       | `www.apicountries.com/alpha/{codice}`                           | country data (language, currency, ...)   |
| Supabase             | tables `trips`, `favorites`, `profiles`, `popular_destinations` | authentication and app data              |

HTTP calls use the `http` package. Loading, errors, and "try again" are handled in the network flows (Explore list, Home, Favorites, Profile, Details).

## Setup

1. `flutter pub get`
2. Copy each `lib/config/*.example.dart` file to the matching `*.dart` file (without `.example`) and add your own keys:
   - `supabase_config.dart`: URL and public key of the Supabase project
   - `unsplash_config.dart`: Unsplash access key
3. `flutter run`
   Configuration files with the real keys must not be committed.

## Notes

- State management uses `setState`; favorites are kept in one place in the main screen and passed down to the child screens.
- Responses from Unsplash, the country API, and the weather API are cached to respect the limits of the free APIs (Unsplash allows about 50 requests per hour in demo mode).
- Weather is only available for dates within the Open-Meteo forecast limit.
