import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:flutter/material.dart';

class UserService{
  final UserRepository userRepository = UserRepository();
  final UserProvider _userProvider;
  UserService(this._userProvider);

  void initializeUser(BuildContext context) async{
    UserDetails userDetails = await userRepository.getUserDetails(context);
    _userProvider.setUserDetails(userDetails);
  }



}