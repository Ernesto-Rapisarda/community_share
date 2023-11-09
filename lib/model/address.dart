class Address {
  String streetName;
  String streetNumber;
  String postalCode;
  String city;


  Address(
      {required this.streetName, required this.streetNumber, required this.postalCode, required this.city});

  toJson() {
    return {
      'streetName': streetName,
      'streetNumber': streetNumber,
      'postalCode': postalCode,
      'city': city
    };
  }

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(streetName: json['streetName'],
        streetNumber: json['streetNumber'],
        postalCode: json['postalCode'],
        city: json['city']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          streetName == other.streetName &&
          streetNumber == other.streetNumber &&
          postalCode == other.postalCode &&
          city == other.city;

  @override
  int get hashCode =>
      streetName.hashCode ^
      streetNumber.hashCode ^
      postalCode.hashCode ^
      city.hashCode;
}