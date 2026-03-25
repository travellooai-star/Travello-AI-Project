import 'package:flight_app/models/weather.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _selectedCity = 'Karachi';
  late WeatherData _currentWeather;

  @override
  void initState() {
    super.initState();
    _currentWeather = PakistanWeatherData.getWeatherForCity(_selectedCity);
  }

  void _changeCity(String city) {
    setState(() {
      _selectedCity = city;
      _currentWeather = PakistanWeatherData.getWeatherForCity(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    final warnings = PakistanWeatherData.getCitiesWithWarnings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Updates'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // City Selector
            Container(
              padding: EdgeInsets.all(spacingUnit(2)),
              color: colorScheme(context).primaryContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: colorScheme(context).onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedCity,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: colorScheme(context).primaryContainer,
                      style: ThemeText.subtitle.copyWith(
                        color: colorScheme(context).onPrimaryContainer,
                      ),
                      items: PakistanWeatherData.getCities().map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) _changeCity(value);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Current Weather Card
            Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(spacingUnit(3)),
                  child: Column(
                    children: [
                      Text(
                        _currentWeather.icon,
                        style: const TextStyle(fontSize: 80),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_currentWeather.temperature.toStringAsFixed(0)}°C',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _currentWeather.condition,
                        style: ThemeText.title.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _WeatherDetail(
                            icon: Icons.water_drop,
                            label: 'Humidity',
                            value: '${_currentWeather.humidity}%',
                          ),
                          _WeatherDetail(
                            icon: Icons.air,
                            label: 'Wind',
                            value: '${_currentWeather.windSpeed} km/h',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Travel Warning (if applicable)
            if (_currentWeather.travelWarning)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                child: Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(spacingUnit(2)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange.shade800,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Travel Warning',
                                style: ThemeText.subtitle.copyWith(
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentWeather.warningMessage,
                                style: ThemeText.caption.copyWith(
                                  color: Colors.orange.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Weather Warnings Section
            if (warnings.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(spacingUnit(2)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Active Weather Alerts',
                    style: ThemeText.title.copyWith(fontSize: 16),
                  ),
                ),
              ),
              ...warnings.map((weather) => _WarningCard(weather: weather)),
            ],

            // All Cities Weather
            Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'All Cities',
                  style: ThemeText.title.copyWith(fontSize: 16),
                ),
              ),
            ),
            ...PakistanWeatherData.getAllCitiesWeather().map((weather) {
              return _CityWeatherTile(
                weather: weather,
                isSelected: weather.city == _selectedCity,
                onTap: () => _changeCity(weather.city),
              );
            }),
            SizedBox(height: spacingUnit(2)),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: colorScheme(context).primary),
        const SizedBox(height: 4),
        Text(label, style: ThemeText.caption),
        Text(value, style: ThemeText.subtitle),
      ],
    );
  }
}

class _WarningCard extends StatelessWidget {
  final WeatherData weather;

  const _WarningCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacingUnit(2),
        vertical: spacingUnit(0.5),
      ),
      child: Card(
        color: Colors.red.shade50,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red.shade100,
            child: Text(
              weather.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          title: Text(
            weather.city,
            style: ThemeText.subtitle.copyWith(
              color: Colors.red.shade900,
            ),
          ),
          subtitle: Text(
            weather.warningMessage,
            style: ThemeText.caption.copyWith(
              color: Colors.red.shade800,
            ),
          ),
          trailing: Icon(
            Icons.warning,
            color: Colors.red.shade700,
          ),
        ),
      ),
    );
  }
}

class _CityWeatherTile extends StatelessWidget {
  final WeatherData weather;
  final bool isSelected;
  final VoidCallback onTap;

  const _CityWeatherTile({
    required this.weather,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacingUnit(2),
        vertical: spacingUnit(0.5),
      ),
      child: Card(
        color: isSelected ? colorScheme(context).primaryContainer : null,
        child: ListTile(
          onTap: onTap,
          leading: Text(
            weather.icon,
            style: const TextStyle(fontSize: 32),
          ),
          title: Text(
            weather.city,
            style: ThemeText.subtitle.copyWith(
              color:
                  isSelected ? colorScheme(context).onPrimaryContainer : null,
            ),
          ),
          subtitle: Text(
            weather.condition,
            style: ThemeText.caption.copyWith(
              color:
                  isSelected ? colorScheme(context).onPrimaryContainer : null,
            ),
          ),
          trailing: Text(
            '${weather.temperature.toStringAsFixed(0)}°C',
            style: ThemeText.title.copyWith(
              fontSize: 16,
              color: isSelected
                  ? colorScheme(context).onPrimaryContainer
                  : colorScheme(context).primary,
            ),
          ),
        ),
      ),
    );
  }
}
