import 'enum/provider.dart';

class UserDetails {
  final String? id;
  String fullName;
  String location;
  String phoneNumber;
  String email;
  ProviderName provider;
  String urlPhotoProfile;

  UserDetails({
    this.id,
    required this.fullName,
    required this.location,
    required this.phoneNumber,
    required this.email,
    required this.provider,
    required this.urlPhotoProfile

});

  toJson(){
    return{
      "FullName": fullName,
      "Location": location,
      "PhoneNumber": phoneNumber,
      "Email": email,
      "Provider": provider.name,
      "PhotoProfile": urlPhotoProfile
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
    );
  }

  @override
  String toString() {
    return 'UserDetails{fullName: $fullName, location: $location, phoneNumber: $phoneNumber, email: $email, provider: ${provider.name}}';
  }


}