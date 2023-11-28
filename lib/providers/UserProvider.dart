import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/enum/provider.dart';
import 'package:community_share/model/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/basic/community_basic.dart';
import '../model/community.dart';
import '../model/product.dart';

class UserProvider with ChangeNotifier{
  bool _firstSignIn = false;
  bool _isLoading = true;
  late UserDetails _userDetails = UserDetails(
    fullName: '',
    location: '',
    phoneNumber: '',
    email: '',
    provider: ProviderName.undefined,
    urlPhotoProfile: '',
    lastTimeOnline: DateTime.now(),
    lastUpdate: DateTime.now(),
    language: 'en',
    theme: 'dark'
  );
  List<Community> _myCommunities = [];
  List<Product> _productsLiked = [];

   //UserDetails(fullName: '', location: '', phoneNumber: '', email: '', provider: ProviderName.undefined, urlPhotoProfile: '', lastTimeOnline: null,lastUpdate: null);




  UserDetails get userDetails => _userDetails;
  bool get firstSignIn => _firstSignIn;
  List<Community> get myCommunities => _myCommunities;
  List<Product> get productLiked => _productsLiked;


  bool get isLoading => _isLoading;

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

  void setData(UserDetails userDetails, List<Community> communities, List<Product> productLiked) {
    _productsLiked = productLiked;
    _userDetails=userDetails;
    //print(_userDetails.toString());
    _myCommunities = communities;
    _isLoading = false;

    notifyListeners();
  }



  UserDetailsBasic getUserBasic(){
    return UserDetailsBasic(
        id: _userDetails.id!,
        fullName: _userDetails.fullName,
        location: _userDetails.location,
        urlPhotoProfile: _userDetails.urlPhotoProfile);
  }

  void addCommunity(Community community){
    _myCommunities.add(community);
    notifyListeners();
  }

  List<CommunityBasic> getListCommunityBasic(){
    List<CommunityBasic> myList = [];
    for(var value in _myCommunities){
      CommunityBasic communityBasic = CommunityBasic(id: value.id, name: value.name, docRef: value.docRef!);
      myList.add(communityBasic);
    }
    return myList;
  }

  void setOrRemoveLikes(BuildContext context,
      Product product) {
    if (_productsLiked.contains(product)) {
      _productsLiked.removeWhere((element) => element.id == product.id);
    } else {
      _productsLiked.add((product));
    }
    notifyListeners();
  }

  void clearAll(){
    _firstSignIn = false;
    _isLoading = true;
    _userDetails = UserDetails(
        fullName: '',
        location: '',
        phoneNumber: '',
        email: '',
        provider: ProviderName.undefined,
        urlPhotoProfile: '',
        lastTimeOnline: DateTime.now(),
        lastUpdate: DateTime.now(),
        language: 'en',
        theme: 'dark'
    );
    _myCommunities = [];
    _productsLiked = [];
  }


}
