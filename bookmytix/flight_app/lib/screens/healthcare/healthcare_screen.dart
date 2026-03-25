import 'package:flight_app/models/hospital.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthcareScreen extends StatefulWidget {
  const HealthcareScreen({super.key});

  @override
  State<HealthcareScreen> createState() => _HealthcareScreenState();
}

class _HealthcareScreenState extends State<HealthcareScreen> {
  String _selectedCity = 'Karachi';
  List<Hospital> _hospitals = [];

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  void _loadHospitals() {
    setState(() {
      _hospitals = PakistanHospitals.getHospitalsByCity(_selectedCity);
    });
  }

  void _changeCity(String city) {
    setState(() {
      _selectedCity = city;
      _loadHospitals();
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emergencyContacts = EmergencyContact.getContacts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthcare Guidance'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacingUnit(2)),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Emergency Healthcare',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find nearby hospitals and emergency contacts',
                    style: ThemeText.caption.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Emergency Contacts Section
            Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Hotlines',
                    style: ThemeText.title.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ...emergencyContacts.map((contact) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: Colors.red.shade50,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.shade100,
                          child: Icon(
                            contact.icon,
                            color: Colors.red.shade900,
                          ),
                        ),
                        title: Text(
                          contact.service,
                          style: ThemeText.subtitle,
                        ),
                        trailing: FilledButton.icon(
                          onPressed: () => _makePhoneCall(contact.number),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                          ),
                          icon: const Icon(Icons.phone, size: 18),
                          label: Text(contact.number),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const Divider(height: 32),

            // City Selector
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nearby Hospitals',
                    style: ThemeText.title.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_city),
                      labelText: 'Select City',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    initialValue: _selectedCity,
                    items: PakistanHospitals.getCities().map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) _changeCity(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Hospitals List
            if (_hospitals.isEmpty)
              Padding(
                padding: EdgeInsets.all(spacingUnit(4)),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_hospital_outlined,
                        size: 64,
                        color: colorScheme(context).outline,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hospitals found',
                        style: ThemeText.subtitle,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...(_hospitals..sort((a, b) => a.distance.compareTo(b.distance)))
                  .map((hospital) {
                return _HospitalCard(
                  hospital: hospital,
                  onCall: () => _makePhoneCall(hospital.phone),
                );
              }),

            SizedBox(height: spacingUnit(2)),
          ],
        ),
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback onCall;

  const _HospitalCard({
    required this.hospital,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacingUnit(2),
        vertical: spacingUnit(0.5),
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(spacingUnit(2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme(context).primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_hospital,
                      color: colorScheme(context).onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hospital.name,
                          style: ThemeText.subtitle,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacingUnit(0.75),
                                vertical: spacingUnit(0.25),
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme(context).tertiaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                hospital.type,
                                style: ThemeText.caption.copyWith(
                                  color:
                                      colorScheme(context).onTertiaryContainer,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            if (hospital.hasEmergency) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacingUnit(0.75),
                                  vertical: spacingUnit(0.25),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '24/7 Emergency',
                                  style: ThemeText.caption.copyWith(
                                    color: Colors.red.shade900,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: colorScheme(context).outline,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      hospital.address,
                      style: ThemeText.caption,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.navigation,
                    size: 16,
                    color: colorScheme(context).outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${hospital.distance.toStringAsFixed(1)} km away',
                    style: ThemeText.caption.copyWith(
                      color: colorScheme(context).primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCall,
                      icon: const Icon(Icons.phone, size: 18),
                      label: Text(hospital.phone),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Navigation feature coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Navigate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
