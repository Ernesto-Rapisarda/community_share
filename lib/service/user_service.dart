import 'package:community_share/model/community.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/community_repository.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';

class UserService{
  final UserRepository _userRepository = UserRepository();
  final CommunityRepository _communityRepository = CommunityRepository();
  //final UserProvider _userProvider;
  //UserService(this._userProvider);

  void initializeUser(BuildContext context) async{
    UserDetails userDetails = await _userRepository.getUserDetails(context);
    List<Community> myCommunities = await _userRepository.getMyCommunities(context);
    List<Product> productsLiked = await _userRepository.getProductsLiked(context);
    //print(productsLiked.length);
    //_userProvider.setData(userDetails,myCommunities);
    context.read<UserProvider>().setData(userDetails, myCommunities, productsLiked);
  }

}