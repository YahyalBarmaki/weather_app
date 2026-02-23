# 📖 Guide d'utilisation - Weather App

## 🚀 Démarrage rapide

### 1. Configuration initiale

```bash
# 1. Récupérer le projet
git clone <votre-repo>
cd weather_app

# 2. Installer les dépendances
flutter pub get

# 3. Configurer la clé API dans .env
OPEN_WEATHER_API_KEY=votre_clé_api_openweather

# 4. Générer le code (si nécessaire)
flutter packages pub run build_runner build

# 5. Lancer l'app
flutter run
```

### 2. Obtenir une clé API OpenWeatherMap

1. Aller sur [OpenWeatherMap](https://openweathermap.org/api)
2. Créer un compte gratuit
3. Générer une clé API
4. Copier la clé dans le fichier `.env`

## 🏗️ Architecture détaillée

### Structure des providers Riverpod

```dart
// Provider principal pour l'état météo
final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>

// Providers utilitaires
final weatherLoadingProvider // Boolean - état de chargement
final weatherListProvider    // List<WeatherEntity> - données météo
final weatherErrorProvider   // String? - message d'erreur
final isDataFreshProvider    // Boolean - fraîcheur des données
```

### Cycle de vie des données

```
1. Chargement initial → WeatherLoading
2. Appel API → Retrofit/Dio
3. Success → WeatherLoaded + Cache
4. Error → WeatherError (avec cache si disponible)
5. Auto-refresh toutes les 30s
```

## 💡 Exemples d'utilisation

### Ajouter une nouvelle ville

```dart
// Dans votre code
ref.read(weatherProvider.notifier).addCityWeather("Barcelona");

// Via l'interface utilisateur
// 1. Appuyer sur le bouton '+' dans l'AppBar
// 2. Saisir le nom de la ville
// 3. Confirmer
```

### Actualiser les données

```dart
// Actualiser toutes les villes
ref.read(weatherProvider.notifier).refreshWeather();

// Actualiser une ville spécifique  
ref.read(weatherProvider.notifier).loadWeatherForSingleCity("Paris");
```

### Gérer les erreurs

```dart
// Écouter les erreurs
final errorMessage = ref.watch(weatherErrorProvider);

if (errorMessage != null) {
  // Afficher un SnackBar ou dialog d'erreur
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage)),
  );
}
```

### Contrôler l'auto-refresh

```dart
final weatherNotifier = ref.read(weatherProvider.notifier);

// Arrêter l'auto-refresh (par exemple quand l'app passe en arrière-plan)
weatherNotifier.stopAutoRefresh();

// Redémarrer l'auto-refresh
weatherNotifier.startAutoRefresh();
```

## 🔧 Personnalisation

### Modifier les villes par défaut

Dans `lib/core/constants/app_constants.dart` :

```dart
static const List<String> defaultCities = [
  'Marrakech',    // Vos villes personnalisées
  'Casablanca',
  'Rabat',
  'Tanger',
  'Agadir'
];
```

### Changer l'intervalle de rafraîchissement

```dart
static const int refreshInterval = 60; // 1 minute au lieu de 30 secondes
```

### Modifier les couleurs des cartes météo

Dans `lib/presentation/widgets/weather_card.dart`, fonction `_getWeatherGradient()` :

```dart
if (weather.temperature > 30) {
  return const LinearGradient(
    colors: [Colors.red, Colors.orange], // Vos couleurs
  );
}
```

### Ajouter de nouveaux champs météo

1. **Modifier l'entité** (`lib/domain/entities/weather_entity.dart`) :
```dart
class WeatherEntity {
  // Champs existants...
  final double? uvIndex;        // Nouveau champ
  final String? sunrise;        // Nouveau champ
  final String? sunset;         // Nouveau champ
}
```

2. **Modifier le modèle** (`lib/data/models/weather_model.dart`) :
```dart
@JsonSerializable()
class WeatherModel extends WeatherEntity {
  // Ajouter les nouveaux champs avec annotations JSON
  @JsonKey(name: 'uvi')
  final double? uvIndex;
}
```

3. **Mettre à jour l'UI** (`lib/presentation/widgets/weather_card.dart`) :
```dart
_buildInfoItem(
  icon: Icons.wb_sunny,
  label: 'UV Index',
  value: '${weather.uvIndex ?? 'N/A'}',
),
```

## 🎨 Customisation UI

### Créer un thème personnalisé

Dans `lib/main.dart` :

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00BCD4), // Votre couleur principale
    brightness: Brightness.light,
  ),
  // Personnaliser d'autres éléments...
),
```

### Ajouter des animations

```dart
// Dans WeatherCard, wrap avec AnimatedContainer
return AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  // Contenu de la carte...
);
```

## 🚫 Gestion d'erreurs

### Types d'erreurs gérées

1. **Erreurs réseau** : Pas de connexion, timeout
2. **Erreurs serveur** : 404 (ville non trouvée), 401 (clé API invalide)
3. **Erreurs de parsing** : Format JSON invalide
4. **Erreurs de cache** : Données expirées, corruption

### Stratégies de fallback

```dart
// 1. Tentative API
// 2. Si échec réseau → Cache local
// 3. Si pas de cache → Message d'erreur
// 4. Retry automatique disponible
```

## 📱 States et navigation

### États possibles

```dart
sealed class WeatherState {
  WeatherInitial    // État initial
  WeatherLoading    // Chargement en cours
  WeatherLoaded     // Données chargées avec succès
  WeatherError      // Erreur avec option de cache
}
```

### Navigation entre états

```dart
// Exemple d'écoute des changements d'état
ref.listen<WeatherState>(weatherProvider, (previous, next) {
  switch (next) {
    case WeatherLoaded():
      // Données chargées
      break;
    case WeatherError():
      // Gérer l'erreur
      if (next.hasCachedData) {
        // Montrer données en cache avec avertissement
      }
      break;
  }
});
```

## 🔍 Debug et monitoring

### Logs disponibles

- **Dio Interceptor** : Logs détaillés des requêtes/réponses API
- **Error Interceptor** : Logs des erreurs avec stack traces
- **Cache operations** : Logs des opérations de cache

### Activer les logs en debug

```dart
// Les logs sont automatiquement activés en mode debug
// Pour les personnaliser, modifier LoggingInterceptor
```

### Monitoring des performances

```dart
// Temps de réponse API disponible dans les logs
// Utilisation mémoire avec Flutter Inspector
// Network usage avec des outils de monitoring
```

## 🧪 Tests

### Tester l'ajout d'une ville

```dart
testWidgets('Should add new city', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(ProviderScope(child: WeatherApp()));
  
  // Act
  await tester.tap(find.byIcon(Icons.add));
  await tester.enterText(find.byType(TextField), 'Barcelona');
  await tester.tap(find.text('Add'));
  
  // Assert
  expect(find.text('Barcelona'), findsOneWidget);
});
```

### Tester la gestion d'erreurs

```dart
test('Should handle network error gracefully', () async {
  // Arrange
  when(mockApiService.getCurrentWeather(any))
    .thenThrow(DioException(requestOptions: RequestOptions(path: '')));
  
  // Act
  final result = await repository.getCurrentWeather('Paris');
  
  // Assert
  expect(result.isLeft(), true);
  result.fold(
    (failure) => expect(failure, isA<NetworkFailure>()),
    (success) => fail('Should not succeed'),
  );
});
```

---

Cette implémentation vous donne une base solide et professionnelle pour une application météo Flutter avec toutes les bonnes pratiques architecturales !