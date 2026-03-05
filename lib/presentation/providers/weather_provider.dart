// ============================================================
//  providers/weather_provider.dart  —  État météo global
//  idle → loading → success / error
// ============================================================

import 'package:flutter/material.dart';
import '../models/weather_city.dart';
import '../services/weather_service.dart';

enum LoadingState { idle, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  LoadingState      _state       = LoadingState.idle;
  List<WeatherCity> _cities      = [];
  double            _progress    = 0.0;
  int               _loadedCount = 0;
  String            _errorMsg    = '';

  LoadingState      get state        => _state;
  List<WeatherCity> get cities       => _cities;
  double            get progress     => _progress;
  int               get loadedCount  => _loadedCount;
  String            get errorMessage => _errorMsg;

  static const _messages = [
    'Nous téléchargeons les données…',
    'C\'est presque fini…',
    'Plus que quelques secondes avant d\'avoir le résultat…',
    'Analyse des prévisions en cours…',
    'Finalisation de votre météo…',
  ];
  String get currentMessage =>
      _messages[_loadedCount.clamp(0, _messages.length - 1)];

  Future<void> loadWeather() async {
    _state = LoadingState.loading;
    _progress = 0.0; _loadedCount = 0;
    _cities = []; _errorMsg = '';
    notifyListeners();

    try {
      _cities = await WeatherService.instance.fetchAllCities(
        onProgress: (loaded, total) {
          _loadedCount = loaded;
          _progress    = loaded / total;
          notifyListeners();
        },
      );
      _progress = 1.0;
      _state    = LoadingState.success;
    } catch (e) {
      _errorMsg = e.toString().replaceFirst('Exception: ', '');
      _state    = LoadingState.error;
    }
    notifyListeners();
  }

  void reset() {
    _state = LoadingState.idle;
    _cities = []; _progress = 0.0;
    _loadedCount = 0; _errorMsg = '';
    notifyListeners();
  }
}