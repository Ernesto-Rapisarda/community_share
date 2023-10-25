import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/enum/provider.dart';
import 'package:community_share/model/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  bool _firstSignIn = false;
  late UserDetails _userDetails ;

   //UserDetails(fullName: '', location: '', phoneNumber: '', email: '', provider: ProviderName.undefined, urlPhotoProfile: '', lastTimeOnline: null,lastUpdate: null);




  UserDetails get userDetails => _userDetails;
  bool get firstSignIn => _firstSignIn;

  void updateUser(
      {String? fullName,
      String? location,
      String? phoneNumber,
      String? email,
     ProviderName? provider,
      String? urlPhotoProfile,
        DateTime? lastTimeOnline,
        DateTime? lastUpdate
      }){
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
    if(urlPhotoProfile != null && _userDetails.urlPhotoProfile != urlPhotoProfile){
      _userDetails.urlPhotoProfile = urlPhotoProfile;
    }
    if(lastTimeOnline != null && _userDetails.lastTimeOnline.isBefore(lastTimeOnline)){
      _userDetails.lastTimeOnline = lastTimeOnline;
    }
    if(lastUpdate != null && _userDetails.lastUpdate.isBefore(lastUpdate)){
      _userDetails.lastUpdate = lastUpdate;
    }
    notifyListeners();
  }

  void setFirstSignIn(){
    _firstSignIn=!_firstSignIn;
  }

  void setUserDetails(UserDetails userDetails) {
    _userDetails=userDetails;
    notifyListeners();
  }

  UserDetailsBasic getUserBasic(){
    return UserDetailsBasic(
        id: 'id_finto'!,
        fullName: _userDetails.fullName,
        location: _userDetails.location,
        urlPhotoProfile: _userDetails.urlPhotoProfile);
  }

}
