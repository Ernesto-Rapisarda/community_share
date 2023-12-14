import 'package:community_share/model/enum/community_type.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/community/components/community_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../model/community.dart';
import 'community_card_join.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Le tue comunità',
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
            SizedBox(height: 16,),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.users,color: Theme.of(context).colorScheme.primary,size: 18,),
                SizedBox(width: 8,),
                Text(
                  'Trova o crea una comunità',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.search,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Imposta la dimensione della casella di testo desiderata

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                    ),
                    //todo controlli per la ricerca
                  ),
                ),
                SizedBox(width: 12,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary
                  ),

                  onPressed: () {
                    context.go('/communities/add');

                    //_showFilterDialog(context);
                  },
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.circlePlus, size: 18,color: Theme.of(context).colorScheme.onPrimary,),
                      SizedBox(width: 6,),
                      Text(AppLocalizations.of(context)!.create, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),),
                    ],
                  ),
                ),
              ],),
            Container(
              height: 550,
              //color: Theme.of(context).colorScheme.secondary,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (Community community in nearCommunities)
                    !myCommunities.contains(community)
                      ?CommunityCardJoin(
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
      ),
    );
  }
}
