import 'package:flutter/material.dart';

class Hospital {
  final String id;
  final String name;
  final String city;
  final String address;
  final String phone;
  final String type;
  final bool hasEmergency;
  final double distance; // in km

  Hospital({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
    required this.type,
    required this.hasEmergency,
    required this.distance,
  });
}

// Dummy Hospital Data for Pakistan
class PakistanHospitals {
  static List<Hospital> getHospitalsByCity(String city) {
    final allHospitals = getAllHospitals();
    return allHospitals.where((h) => h.city == city).toList();
  }

  static List<Hospital> getAllHospitals() {
    return [
      // Karachi
      Hospital(
        id: '1',
        name: 'Aga Khan University Hospital',
        city: 'Karachi',
        address: 'Stadium Road, Karachi',
        phone: '021-34864000',
        type: 'Multi-Specialty',
        hasEmergency: true,
        distance: 2.5,
      ),
      Hospital(
        id: '2',
        name: 'Jinnah Postgraduate Medical Centre',
        city: 'Karachi',
        address: 'Rafiqui Shaheed Road, Karachi',
        phone: '021-99201300',
        type: 'Government',
        hasEmergency: true,
        distance: 3.8,
      ),
      Hospital(
        id: '3',
        name: 'Liaquat National Hospital',
        city: 'Karachi',
        address: 'Stadium Road, Karachi',
        phone: '021-111-456-456',
        type: 'Multi-Specialty',
        hasEmergency: true,
        distance: 2.1,
      ),

      // Lahore
      Hospital(
        id: '4',
        name: 'Shaukat Khanum Memorial Cancer Hospital',
        city: 'Lahore',
        address: '7-A Block R-3, Johar Town, Lahore',
        phone: '042-35905000',
        type: 'Cancer Specialty',
        hasEmergency: true,
        distance: 4.2,
      ),
      Hospital(
        id: '5',
        name: 'Services Hospital',
        city: 'Lahore',
        address: 'Jail Road, Lahore',
        phone: '042-99213274',
        type: 'Government',
        hasEmergency: true,
        distance: 3.5,
      ),
      Hospital(
        id: '6',
        name: 'Hameed Latif Hospital',
        city: 'Lahore',
        address: '14 Abu Baker Block, Garden Town, Lahore',
        phone: '042-35713333',
        type: 'Multi-Specialty',
        hasEmergency: true,
        distance: 2.9,
      ),

      // Islamabad
      Hospital(
        id: '7',
        name: 'Shifa International Hospital',
        city: 'Islamabad',
        address: 'H-8/4, Islamabad',
        phone: '051-8463000',
        type: 'Multi-Specialty',
        hasEmergency: true,
        distance: 5.1,
      ),
      Hospital(
        id: '8',
        name: 'Pakistan Institute of Medical Sciences (PIMS)',
        city: 'Islamabad',
        address: 'G-8/3, Islamabad',
        phone: '051-9261170',
        type: 'Government',
        hasEmergency: true,
        distance: 4.6,
      ),
      Hospital(
        id: '9',
        name: 'Quaid-e-Azam International Hospital',
        city: 'Islamabad',
        address: 'G-10/4, Islamabad',
        phone: '051-9253901',
        type: 'Multi-Specialty',
        hasEmergency: true,
        distance: 3.8,
      ),

      // Rawalpindi
      Hospital(
        id: '10',
        name: 'Fauji Foundation Hospital',
        city: 'Rawalpindi',
        address: 'Peshawar Road, Rawalpindi',
        phone: '051-9271011',
        type: 'Multi-Specialty',
        hasEmergency: true,
        distance: 2.3,
      ),
      Hospital(
        id: '11',
        name: 'Combined Military Hospital (CMH)',
        city: 'Rawalpindi',
        address: 'Mall Road, Rawalpindi Cantt',
        phone: '051-9270614',
        type: 'Military Hospital',
        hasEmergency: true,
        distance: 3.2,
      ),

      // Multan
      Hospital(
        id: '12',
        name: 'Nishtar Medical University Hospital',
        city: 'Multan',
        address: 'Nishtar Road, Multan',
        phone: '061-9200260',
        type: 'Government',
        hasEmergency: true,
        distance: 1.8,
      ),

      // Faisalabad
      Hospital(
        id: '13',
        name: 'Allied Hospital',
        city: 'Faisalabad',
        address: 'Sargodha Road, Faisalabad',
        phone: '041-9201100',
        type: 'Government',
        hasEmergency: true,
        distance: 2.5,
      ),

      // Peshawar
      Hospital(
        id: '14',
        name: 'Hayatabad Medical Complex',
        city: 'Peshawar',
        address: 'Phase 5, Hayatabad, Peshawar',
        phone: '091-9217140',
        type: 'Government',
        hasEmergency: true,
        distance: 6.2,
      ),
      Hospital(
        id: '15',
        name: 'Khyber Teaching Hospital',
        city: 'Peshawar',
        address: 'Jamrud Road, Peshawar',
        phone: '091-9211463',
        type: 'Government',
        hasEmergency: true,
        distance: 3.9,
      ),

      // Quetta
      Hospital(
        id: '16',
        name: 'Bolan Medical Complex Hospital',
        city: 'Quetta',
        address: 'Brewery Road, Quetta',
        phone: '081-9202624',
        type: 'Government',
        hasEmergency: true,
        distance: 2.7,
      ),
    ];
  }

  static List<String> getCities() {
    return getAllHospitals().map((h) => h.city).toSet().toList()..sort();
  }

  static List<Hospital> getEmergencyHospitals() {
    return getAllHospitals().where((h) => h.hasEmergency).toList();
  }
}

class EmergencyContact {
  final String service;
  final String number;
  final IconData icon;

  EmergencyContact({
    required this.service,
    required this.number,
    required this.icon,
  });

  static List<EmergencyContact> getContacts() {
    return [
      EmergencyContact(
        service: 'Emergency (Rescue 1122)',
        number: '1122',
        icon: Icons.emergency,
      ),
      EmergencyContact(
        service: 'Police',
        number: '15',
        icon: Icons.local_police,
      ),
      EmergencyContact(
        service: 'Ambulance (Edhi)',
        number: '115',
        icon: Icons.local_hospital,
      ),
      EmergencyContact(
        service: 'Fire Brigade',
        number: '16',
        icon: Icons.fire_truck,
      ),
    ];
  }
}
