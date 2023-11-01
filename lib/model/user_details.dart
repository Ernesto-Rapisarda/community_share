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



  UserDetails({
    this.id,
    required this.fullName,
    required this.location,
    required this.phoneNumber,
    required this.email,
    required this.provider,
    required this.urlPhotoProfile,
    required this.lastTimeOnline,
    required this.lastUpdate

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
      "LastUpdate": lastUpdate
    };
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      fullName: json['FullName'] ?? '',
      location: json['Location'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      email: json['Email'] ?? '',
      provider: ProviderName.values.contains(json['Provider'])
          ? ProviderName.values.firstWhere((element) => element.toString() == 'ProviderName.${json['Provider']}', orElse: () => ProviderName.undefined)
          : ProviderName.undefined,
      urlPhotoProfile: json['PhotoProfile'] ?? '',
      lastTimeOnline: (json['LastTimeOnline'] as Timestamp).toDate(),
      lastUpdate: (json['LastUpdate'] as Timestamp).toDate(),


    );
  }

  @override
  String toString() {
    return 'UserDetails{id: $id, fullName: $fullName, location: $location, phoneNumber: $phoneNumber, email: $email, provider: $provider, urlPhotoProfile: $urlPhotoProfile, lastTimeOnline: $lastTimeOnline, lastUpdate: $lastUpdate}';
  }
}