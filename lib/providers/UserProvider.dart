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
  int _unreadMessage = 0;
   //UserDetails(fullName: '', location: '', phoneNumber: '', email: '', provider: ProviderName.undefined, urlPhotoProfile: '', lastTimeOnline: null,lastUpdate: null);

  void updateUnreadMessage(int value){
    _unreadMessage = value;
    notifyListeners();
  }


  UserDetails get userDetails => _userDetails;
  bool get firstSignIn => _firstSignIn;
  List<Community> get myCommunities => _myCommunities;
  List<Product> get productLiked => _productsLiked;


  int get unreadMessage => _unreadMessage;

  set firstSignIn(bool value){
    _firstSignIn = value;
  }

  set unreadMessage(int value) {
    _unreadMessage = value;
  }

  bool get isLoading => _isLoading;

  void updateUser(UserDetails userDetails){
    _userDetails = userDetails;
    notifyListeners();
  }

  void setFirstSignIn(){
    _firstSignIn=!_firstSignIn;
  }

  void setData(UserDetails userDetails, List<Community> communities, List<Product> productLiked, int unreadMessage) {
    _productsLiked = productLiked;
    _userDetails=userDetails;
    //print(_userDetails.toString());
    _myCommunities = communities;
    _unreadMessage = unreadMessage;
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
