# Weather App - Flutter

Une application météo Flutter implémentée avec Clean Architecture, utilisant l'API OpenWeatherMap pour récupérer les données météorologiques en temps réel de 5 villes différentes.

## 🏗️ Architecture

L'application suit les principes de **Clean Architecture** avec une séparation claire en couches :

```
lib/
├── core/                    # Fonctionnalités partagées
│   ├── constants/           # Constantes de l'application
│   ├── error/              # Gestion des erreurs et exceptions
│   ├── network/            # Configuration réseau (Dio, interceptors)
│   └── di/                 # Injection de dépendances
├── data/                   # Couche de données
│   ├── models/             # Modèles de données (JSON)
│   ├── datasources/        # Sources de données (API, Cache)
│   └── repositories/       # Implémentation des repositories
├── domain/                 # Couche métier
│   ├── entities/           # Entités métier
│   ├── repositories/       # Interfaces des repositories
│   └── usecases/          # Cas d'usage
└── presentation/          # Couche présentation
    ├── providers/         # Providers Riverpod
    ├── pages/            # Pages de l'application
    └── widgets/          # Widgets réutilisables
```

## ✨ Fonctionnalités

### 🌤️ Météo en temps réel
- Récupération automatique des données météo pour 5 villes par défaut
- Possibilité d'ajouter/supprimer des villes
- Actualisation automatique toutes les 30 secondes
- Données mises en cache pour une utilisation hors ligne

### 🔧 Architecture technique
- **State Management** : Riverpod avec StateNotifier
- **API Calls** : Retrofit + Dio avec interceptors
- **Error Handling** : Pattern Either (dartz) pour la gestion d'erreurs
- **Dependency Injection** : get_it
- **Caching** : SharedPreferences avec gestion d'expiration
- **Security** : Clé API sécurisée via variables d'environnement

### 🎨 Interface utilisateur
- Design moderne avec Material 3
- Cards météo avec gradients colorés
- Indicateurs de fraîcheur des données
- Gestion des états d'erreur avec données en cache
- Interface responsive

## 🚀 Installation

### Prérequis
- Flutter 3.5.4+
- Dart 3.0+
- Clé API OpenWeatherMap

### Configuration

1. **Cloner le repository**
```bash
git clone <repository-url>
cd weather_app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer la clé API**

Modifier le fichier `.env` :
```env
OPEN_WEATHER_API_KEY=votre_clé_api_ici
BASE_URL=https://api.openweathermap.org/data/2.5/
```

Pour obtenir une clé API gratuite :
- Créer un compte sur [OpenWeatherMap](https://openweathermap.org/api)
- Générer une clé API
- Remplacer `your_api_key_here` par votre clé

4. **Générer le code**
```bash
flutter packages pub run build_runner build
```

5. **Lancer l'application**
```bash
flutter run
```

## 🔧 Configuration avancée

### Modifier les villes par défaut

Dans `lib/core/constants/app_constants.dart` :
```dart
static const List<String> defaultCities = [
  'Paris',
  'London',
  'Tokyo',
  'New York',
  'Sydney'
];
```

### Modifier l'intervalle de rafraîchissement

```dart
static const int refreshInterval = 30; // secondes
```

### Configuration du cache

```dart
static const int cacheValidityHours = 1; // heures
```

## 📱 Utilisation

### Écran principal
- Visualisation des cartes météo pour chaque ville
- Température actuelle, ressenti, description
- Humidité, vitesse du vent, pression
- Horodatage de la dernière mise à jour

### Interactions
- **Ajouter une ville** : Bouton `+` dans l'AppBar
- **Actualiser** : Bouton refresh dans l'AppBar ou sur chaque carte
- **Supprimer une ville** : Bouton `×` sur chaque carte (minimum 1 ville)
- **Pull-to-refresh** : Glisser vers le bas pour actualiser

### Gestion hors ligne
- Les données sont automatiquement mises en cache
- En cas de perte de connexion, affichage des données en cache
- Indicateur visuel pour les données périmées

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter drive --target=test_driver/app.dart
```

## 📦 Dépendances principales

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.4.9
  
  # HTTP & API
  dio: ^5.4.0
  retrofit: ^4.0.3
  json_annotation: ^4.8.1
  
  # Error Handling
  dartz: ^0.10.1
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Environment Variables
  flutter_dotenv: ^5.1.0
  
  # Autres...
```

## 🔐 Sécurité

- **Clé API** : Stockée dans variables d'environnement (.env)
- **HTTPS** : Toutes les communications API en HTTPS
- **Validation** : Validation des entrées utilisateur
- **Error Handling** : Gestion robuste des erreurs sans exposition d'informations sensibles

## 🐛 Résolution des problèmes

### Erreur "API key required"
- Vérifier que la clé API est configurée dans `.env`
- S'assurer que la clé API est active sur OpenWeatherMap

### Erreur de build
```bash
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Problèmes de réseau
- Vérifier la connexion internet
- Les données en cache s'affichent automatiquement en mode hors ligne

## 📈 Améliorations possibles

- [ ] Géolocalisation pour la ville actuelle
- [ ] Prévisions météo sur plusieurs jours
- [ ] Notifications push pour alertes météo
- [ ] Thème sombre/clair
- [ ] Widgets pour l'écran d'accueil
- [ ] Graphiques de tendances météo
- [ ] Support de plusieurs langues

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Committer les changements (`git commit -m 'Add AmazingFeature'`)
4. Pousser vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Distribué sous licence MIT. Voir `LICENSE` pour plus d'informations.

---

**Développé avec ❤️ en Flutter**
