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
      id: json['id'],
      fullName: json['FullName'] ?? '',
      location: json['Location'] ?? '',
      urlPhotoProfile: json['PhotoProfile'] ?? ''
    );
  }
}