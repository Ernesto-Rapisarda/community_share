

import 'package:community_share/model/basic/community_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/product.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../model/address.dart';
import '../model/community.dart';
import '../model/product_order.dart';
import '../providers/UserProvider.dart';
import '../reporitory/community_repository.dart';

class CommunityService{
  final CommunityRepository _communityRepository= CommunityRepository();

  void createCommunity(BuildContext context, Community community)async{
    await _communityRepository.createCommunity(context, community);
  }

  Future<List<Community>> getMyCommunities(BuildContext context) async{
    return await _communityRepository.getMyCommunities(context);
  }

  Future<void> joinCommunity(BuildContext context, Community community) async{
    if (Auth().currentUser?.uid == community.founder.id) {
      throw Exception('You cannot join a community you founded.');
    }

    if (context.read<UserProvider>().myCommunities.contains(community)) {
      throw Exception('You are already a member of this community.');
    }

    await _communityRepository.joinCommunity(context, community);
    context.read<UserProvider>().addCommunity(community);
  }

  Future<void> getEventsForCommunity(BuildContext context) async{
    context.read<CommunityProvider>().events = await _communityRepository.getEventsForCommunity(context);
  }

  Future<List<UserDetailsBasic>> getMembers(BuildContext context) async{
    return await _communityRepository.getMembers(context);
  }

  Future<List<Community>> getAllCommunities(BuildContext context) async{
    return await _communityRepository.getAllCommunities(context);
  }

  Future<List<Product>> getCommunitysProducts(BuildContext context) async{
    return await _communityRepository.getCommunitysProducts(context);
  }

  Future<void> updateCommunity(BuildContext context, Community community) async{
    return await _communityRepository.updateCommunity(context, community);
  }

  Future<Address?> retrieveCommunityAddress(BuildContext context, CommunityBasic communityBasic) async{
    return await _communityRepository.retrieveCommunityAddress(context,communityBasic);
  }

  Future<List<ProductOrder>> getCommunityOrders(BuildContext context, String docRef) async{
    return await _communityRepository.getCommunityOrders(context,docRef);
  }

}