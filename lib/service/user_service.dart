import 'package:community_share/model/community.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserService{
  final UserRepository userRepository = UserRepository();
  //final UserProvider _userProvider;
  //UserService(this._userProvider);

  void initializeUser(BuildContext context) async{
    UserDetails userDetails = await userRepository.getUserDetails(context);
    List<Community> myCommunities = await userRepository.getMyCommunities(context);
    //_userProvider.setData(userDetails,myCommunities);
    context.read<UserProvider>().setData(userDetails, myCommunities);
  }

}