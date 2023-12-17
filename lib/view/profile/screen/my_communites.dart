import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../model/community.dart';
import '../../../service/community_service.dart';
import '../../community/components/community_card.dart';

class MyCommunities extends StatefulWidget {
  const MyCommunities({super.key});

  @override
  State<MyCommunities> createState() => _MyCommunitiesState();
}

class _MyCommunitiesState extends State<MyCommunities> {
  List<Community> myCommunities = [];
  final CommunityService _communityService = CommunityService();
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchCommunity();
  }

  void fetchCommunity(){
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    myCommunities = context.watch<UserProvider>().myCommunities;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            AppLocalizations.of(context)!.pageCommunities,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: isLoading
                  ? CircularLoadingIndicator.circularInd(context)
                  : myCommunities.length > 0
                  ? Container(
                height: 450,
                //width: 300,
                //color: Theme.of(context).colorScheme.secondary,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 4/7,
                  ),
                  itemCount: myCommunities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CommunityCard(
                      community: myCommunities[index],
                      myCommunities: true,
                    );
                  },
                ),
              )
                  : Container(
                height: 80,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.nothingToShow,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),


          ),
        ));
  }
}
