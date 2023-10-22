import 'enum/provider.dart';

class UserDetails {
  final String? id;
  String fullName;
  String location;
  String phoneNumber;
  String email;
  ProviderName provider;

  UserDetails({
    this.id,
    required this.fullName,
    required this.location,
    required this.phoneNumber,
    required this.email,
    required this.provider

});

  toJson(){
    return{
      "FullName": fullName,
      "Location": location,
      "PhoneNumber": phoneNumber,
      "Email": email,
      "Provider": provider
    };
  }
}