

import 'package:community_share/providers/community_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../model/community.dart';
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
    return await _communityRepository.joinCommunity(context,community);
  }

  Future<void> getEventsForCommunity(BuildContext context) async{
    context.read<CommunityProvider>().events = await _communityRepository.getEventsForCommunity(context);
  }

}