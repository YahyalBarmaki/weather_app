// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      cityName: json['name'] as String,
      sys: SysModel.fromJson(json['sys'] as Map<String, dynamic>),
      main: MainModel.fromJson(json['main'] as Map<String, dynamic>),
      wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => WeatherDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      visibility: (json['visibility'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'name': instance.cityName,
      'sys': instance.sys,
      'main': instance.main,
      'wind': instance.wind,
      'weather': instance.weather,
      'visibility': instance.visibility,
    };

SysModel _$SysModelFromJson(Map<String, dynamic> json) => SysModel(
      country: json['country'] as String,
    );

Map<String, dynamic> _$SysModelToJson(SysModel instance) => <String, dynamic>{
      'country': instance.country,
    };

MainModel _$MainModelFromJson(Map<String, dynamic> json) => MainModel(
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      pressure: (json['pressure'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MainModelToJson(MainModel instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
    };

WindModel _$WindModelFromJson(Map<String, dynamic> json) => WindModel(
      speed: (json['speed'] as num).toDouble(),
    );

Map<String, dynamic> _$WindModelToJson(WindModel instance) => <String, dynamic>{
      'speed': instance.speed,
    };

WeatherDetailsModel _$WeatherDetailsModelFromJson(Map<String, dynamic> json) =>
    WeatherDetailsModel(
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherDetailsModelToJson(
        WeatherDetailsModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'icon': instance.icon,
    };