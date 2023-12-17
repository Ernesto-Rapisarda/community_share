import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/community_repository.dart';
import 'package:community_share/reporitory/conversation_repository.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';

class UserService{
  final UserRepository _userRepository = UserRepository();
  final CommunityRepository _communityRepository = CommunityRepository();
  final ConversationRepository _conversationRepository = ConversationRepository();
  //final UserProvider _userProvider;
  //UserService(this._userProvider);

  Future<void> initializeUser(BuildContext context) async{
    UserDetails userDetails = await _userRepository.getUserDetails(context);
    List<Community> myCommunities = await _userRepository.getMyCommunities(context);
    List<Product> productsLiked = await _userRepository.getProductsLiked(context);
    int unreadedMessage = await _conversationRepository.unreadedMessageNumber();
    //print(productsLiked.length);
    //_userProvider.setData(userDetails,myCommunities);
    context.read<UserProvider>().setData(userDetails, myCommunities, productsLiked, unreadedMessage);
  }

  Future<List<ProductOrder>> getMyOrders(BuildContext context, bool outcoming) async{
    return await _userRepository.getMyOrders(context,outcoming);
  }

  Future<List<Product>> getUserProducts(String id) async{
    try{
      return _userRepository.getUserProducts(id);
    }catch (e) {
      rethrow;
    }
  }

  Future<List<Community>> getUserCommunities(String id) async{
    try{
      return _userRepository.getUserCommunities(id);
    }catch (e) {
      rethrow;
    }
  }

  Future<UserDetails> getUserByIdDoc(String id) async{
    try{
      return await _userRepository.getUserByIdDoc(id);
    }catch (error){
      rethrow;
    }
  }

  Future<List<Product>> getUserProductsFromCollection(String collection) async{
    try
    {
      return await _userRepository.getUserProductsFromCollection(collection);

    }
    catch (error)
    {
      rethrow;
    }
  }

}