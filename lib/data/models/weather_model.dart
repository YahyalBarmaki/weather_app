import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/weather_entity.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel extends WeatherEntity {
  @JsonKey(name: 'name')
  final String cityName;
  
  @JsonKey(name: 'sys')
  final SysModel sys;
  
  @JsonKey(name: 'main')
  final MainModel main;
  
  @JsonKey(name: 'wind')
  final WindModel wind;
  
  @JsonKey(name: 'weather')
  final List<WeatherDetailsModel> weather;
  
  @JsonKey(name: 'visibility')
  final int? visibility;
  
  const WeatherModel({
    required this.cityName,
    required this.sys,
    required this.main,
    required this.wind,
    required this.weather,
    this.visibility,
  }) : super(
          cityName: cityName,
          country: sys.country,
          temperature: main.temp,
          feelsLike: main.feelsLike,
          humidity: main.humidity,
          windSpeed: wind.speed,
          description: weather.isNotEmpty ? weather.first.description : '',
          icon: weather.isNotEmpty ? weather.first.icon : '',
          lastUpdated: DateTime.now(),
          pressure: main.pressure,
          visibility: visibility,
        );
  
  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
  
  WeatherEntity toEntity() {
    return WeatherEntity(
      cityName: cityName,
      country: sys.country,
      temperature: main.temp,
      feelsLike: main.feelsLike,
      humidity: main.humidity,
      windSpeed: wind.speed,
      description: weather.isNotEmpty ? weather.first.description : '',
      icon: weather.isNotEmpty ? weather.first.icon : '',
      lastUpdated: DateTime.now(),
      pressure: main.pressure,
      visibility: visibility,
    );
  }
}

@JsonSerializable()
class SysModel {
  @JsonKey(name: 'country')
  final String country;
  
  const SysModel({required this.country});
  
  factory SysModel.fromJson(Map<String, dynamic> json) =>
      _$SysModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$SysModelToJson(this);
}

@JsonSerializable()
class MainModel {
  @JsonKey(name: 'temp')
  final double temp;
  
  @JsonKey(name: 'feels_like')
  final double feelsLike;
  
  @JsonKey(name: 'humidity')
  final int humidity;
  
  @JsonKey(name: 'pressure')
  final double? pressure;
  
  const MainModel({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    this.pressure,
  });
  
  factory MainModel.fromJson(Map<String, dynamic> json) =>
      _$MainModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$MainModelToJson(this);
}

@JsonSerializable()
class WindModel {
  @JsonKey(name: 'speed')
  final double speed;
  
  const WindModel({required this.speed});
  
  factory WindModel.fromJson(Map<String, dynamic> json) =>
      _$WindModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$WindModelToJson(this);
}

@JsonSerializable()
class WeatherDetailsModel {
  @JsonKey(name: 'description')
  final String description;
  
  @JsonKey(name: 'icon')
  final String icon;
  
  const WeatherDetailsModel({
    required this.description,
    required this.icon,
  });
  
  factory WeatherDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherDetailsModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$WeatherDetailsModelToJson(this);
}