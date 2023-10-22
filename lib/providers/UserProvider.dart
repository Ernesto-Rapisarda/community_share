import 'package:community_share/model/enum/provider.dart';
import 'package:community_share/model/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  bool _firstSignIn = false;
  UserDetails _userDetails = UserDetails(fullName: '', location: '', phoneNumber: '', email: '', provider: ProviderName.undefined);

  UserDetails get userDetails => _userDetails;
  bool get firstSignIn => _firstSignIn;

  void setUser(
      {String? fullName,
      String? location,
      String? phoneNumber,
      String? email,
     ProviderName? provider}){
    if(fullName != null && _userDetails.fullName != fullName){
      _userDetails.fullName = fullName;
    }
    if(location != null && _userDetails.location != location){
      _userDetails.location = location;
    }
    if(fullName != null && _userDetails.fullName != fullName){
      _userDetails.fullName = fullName;
    }
    if(phoneNumber != null && _userDetails.phoneNumber != phoneNumber){
      _userDetails.phoneNumber = phoneNumber;
    }
    if(email != null && _userDetails.email != email){
      _userDetails.email = email;
    }
    if(provider != null && _userDetails.provider != provider){
      _userDetails.provider = provider;
    }
    notifyListeners();
  }

  void setFirstSignIn(){
    _firstSignIn=!_firstSignIn;
  }

}
