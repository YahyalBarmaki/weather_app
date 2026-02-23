import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../providers/weather_state.dart';
import '../widgets/weather_card.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherProvider.notifier).loadWeatherForDefaultCities();
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _scrollController.dispose();
    ref.read(weatherProvider.notifier).stopAutoRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showRefreshDialog,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            tooltip: 'Refresh All',
          ),
          IconButton(
            onPressed: _showAddCityDialog,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            tooltip: 'Add City',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
              Color(0xFF90CAF9),
            ],
          ),
        ),
        child: _buildBody(weatherState),
      ),
    );
  }

  Widget _buildBody(WeatherState state) {
    return switch (state) {
      WeatherInitial() => _buildInitialState(),
      WeatherLoading() => _buildLoadingState(),
      WeatherLoaded() => _buildLoadedState(state),
      WeatherError() => _buildErrorState(state),
    };
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud,
            size: 100,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'Weather App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the + button to add a city',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Loading weather data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(WeatherLoaded state) {
    if (state.weatherList.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        if (!state.isDataFresh)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.orange.withOpacity(0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Data might be outdated',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => ref.read(weatherProvider.notifier).refreshWeather(),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: state.weatherList.length,
            itemBuilder: (context, index) {
              final weather = state.weatherList[index];
              return WeatherCard(
                weather: weather,
                onRefresh: () => _refreshSingleCity(weather.cityName),
                onRemove: state.weatherList.length > 1
                    ? () => _removeCityWeather(weather.cityName)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(WeatherError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.failure.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(weatherProvider.notifier).refreshWeather(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
            if (state.hasCachedData) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => _showCachedData(state.cachedWeatherList!),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text(
                  'Show Cached Data',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off,
            size: 100,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'No weather data available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a city to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddCityDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add City'),
          ),
        ],
      ),
    );
  }

  void _showAddCityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add City'),
        content: TextField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'City Name',
            hintText: 'Enter city name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (_) => _addCity(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cityController.clear();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addCity,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showRefreshDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refresh Weather'),
        content: const Text('Do you want to refresh all weather data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(weatherProvider.notifier).refreshWeather();
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  void _showCachedData(List<dynamic> cachedData) {
    // Implement showing cached data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Showing cached weather data'),
      ),
    );
  }

  void _addCity() {
    final cityName = _cityController.text.trim();
    if (cityName.isNotEmpty) {
      ref.read(weatherProvider.notifier).addCityWeather(cityName);
      Navigator.of(context).pop();
      _cityController.clear();
    }
  }

  void _refreshSingleCity(String cityName) {
    ref.read(weatherProvider.notifier).loadWeatherForSingleCity(cityName);
  }

  void _removeCityWeather(String cityName) {
    ref.read(weatherProvider.notifier).removeCityWeather(cityName);
  }
}