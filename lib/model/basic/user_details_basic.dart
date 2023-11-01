import 'package:flutter/material.dart';

class UserDetailsBasic {
  String id;
  String fullName;
  String location;
  String urlPhotoProfile;

  UserDetailsBasic({required this.id,required this.fullName,required this.location,required this.urlPhotoProfile});

  toJson(){
    return{
      "Id": id,
      "FullName": fullName,
      "Location": location,
      "PhotoProfile": urlPhotoProfile,
    };
  }

  factory UserDetailsBasic.fromJson(Map<String, dynamic> json){
    return UserDetailsBasic(
      id: json['Id'] ?? '',
      fullName: json['FullName'] ?? '',
      location: json['Location'] ?? '',
      urlPhotoProfile: json['PhotoProfile'] ?? ''
    );
  }

  @override
  String toString() {
    return 'UserDetailsBasic{id: $id, fullName: $fullName, location: $location, urlPhotoProfile: $urlPhotoProfile}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsBasic &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName;

  @override
  int get hashCode => id.hashCode ^ fullName.hashCode;
}