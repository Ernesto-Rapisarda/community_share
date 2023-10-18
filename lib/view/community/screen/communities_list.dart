import 'package:community_share/model/enum/community_type.dart';
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

  @override
  void initState() {
    super.initState();
    fetchCommunitiesData();
  }

  void fetchCommunitiesData() {
    // Popola la lista myCommunities
    Community myCommunity1 = Community();
    myCommunity1.members = ['ciao', 'ciao1', 'ciao2'];
    myCommunity1.locationSite = 'Milano';
    myCommunity1.type = CommunityType.religiousInstitution;
    myCommunity1.urlLogo = 'assets/images/chiesa_nocera.jpg';
    myCommunity1.name = 'Chiesa di Nocera bla bla bla';
    for (int i = 0; i < 10; i++) {
      myCommunities.add(myCommunity1);
      nearCommunities.add(myCommunity1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Le tue communities',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 200,
          color: Theme.of(context).colorScheme.secondary,
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
          color: Theme.of(context).colorScheme.secondary,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (Community community in myCommunities)
                CommunityCard(community)
            ],
          ),
        ),
      ],
    );
  }
}
