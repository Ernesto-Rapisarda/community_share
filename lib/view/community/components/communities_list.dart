import 'package:community_share/model/enum/community_type.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/community/components/community_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/community.dart';

class CommunitiesList extends StatefulWidget {
  const CommunitiesList({super.key});

  @override
  State<CommunitiesList> createState() => _CommunitiesListState();
}

class _CommunitiesListState extends State<CommunitiesList> {
  List<Community> myCommunities = [];
  List<Community> nearCommunities = [];
  final CommunityService _communityService = CommunityService();
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCommunitiesData();
  }

  void fetchCommunitiesData() async {
    List<Community> communities = context.watch<UserProvider>().myCommunities;
    List<Community> allCommunities =
        await _communityService.getAllCommunities(context);
    setState(() {
      myCommunities = communities;
      nearCommunities = allCommunities;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularLoadingIndicator.circularInd(context);
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Le tue communities',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),
          ),
          myCommunities.length > 0
              ? Container(
                  height: 350,
                  //width: 300,
                  //color: Theme.of(context).colorScheme.secondary,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (Community community in myCommunities)
                        CommunityCard(
                          community: community,
                          myCommunities: true,
                        )
                    ],
                  ),
                )
              : Container(
            height: 80,
                child: Center(
                  child: Text(
                      'Nothing to show ... please join a community',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                ),
              ),
          Text(
            'Le communities vicino a te',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),
          ),
          Container(
            height: 390,
            //color: Theme.of(context).colorScheme.secondary,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (Community community in nearCommunities)
                  !myCommunities.contains(community)
                    ?CommunityCard(
                      community: community,
                      myCommunities: false,
                    )
                      :Center()


              ],
            ),
          ),
          SizedBox(height: 80,)
        ],
      ),
    );
  }
}
