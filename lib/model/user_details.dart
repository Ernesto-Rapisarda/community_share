import 'package:cloud_firestore/cloud_firestore.dart';

import 'enum/provider.dart';

class UserDetails {
  String? id;
  String fullName;
  String location;
  String phoneNumber;
  String email;
  ProviderName provider;
  String urlPhotoProfile;
  DateTime lastTimeOnline;
  DateTime lastUpdate;
  String language;
  String theme;



  UserDetails({
    this.id,
    required this.fullName,
    required this.location,
    required this.phoneNumber,
    required this.email,
    required this.provider,
    required this.urlPhotoProfile,
    required this.lastTimeOnline,
    required this.lastUpdate,
    required this.language,
    required this.theme

});

  toJson(){
    return{
      "FullName": fullName,
      "Location": location,
      "PhoneNumber": phoneNumber,
      "Email": email,
      "Provider": provider.name,
      "PhotoProfile": urlPhotoProfile,
      "LastTimeOnline": lastTimeOnline,
      "LastUpdate": lastUpdate,
      "language": language,
      "theme":theme
    };
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      fullName: json['FullName'] ?? '',
      location: json['Location'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      email: json['Email'] ?? '',
      provider: providerNameFromString(json['Provider']),
      urlPhotoProfile: json['PhotoProfile'] ?? '',
      lastTimeOnline: (json['LastTimeOnline'] as Timestamp).toDate(),
      lastUpdate: (json['LastUpdate'] as Timestamp).toDate(),
      language: json['language'],
      theme: json['theme']


    );
  }

  @override
  String toString() {
    return 'UserDetails{id: $id, fullName: $fullName, location: $location, phoneNumber: $phoneNumber, email: $email, provider: $provider, urlPhotoProfile: $urlPhotoProfile, lastTimeOnline: $lastTimeOnline, lastUpdate: $lastUpdate}';
  }
}