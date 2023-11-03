import 'package:community_share/model/enum/community_type.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/community/components/community_card.dart';
import 'package:flutter/material.dart';

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
    List<Community> communities = await _communityService.getMyCommunities(context);
    List<Community> allCommunities = await _communityService.getAllCommunities(context);
    setState(() {
      myCommunities = communities;
      nearCommunities = allCommunities;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator(); // Visualizza un indicatore di caricamento finché i dati non sono pronti
    }
    return Column(
      children: [
        Text(
          'Le tue communities',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 200,
          //color: Theme.of(context).colorScheme.secondary,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (Community community in myCommunities)
                CommunityCard(community)
            ],
          ),
        ),
        Text(
          'Le communities vicino a te',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 200,
          //color: Theme.of(context).colorScheme.secondary,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (Community community in nearCommunities)
                CommunityCard(community)
            ],
          ),
        ),
      ],
    );
  }
}
