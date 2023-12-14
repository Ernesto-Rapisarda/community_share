import 'package:community_share/main.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/utils/show_snack_bar.dart';
import 'package:community_share/view/community/screen/community_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/UserProvider.dart';

class CommunityCard extends StatefulWidget {
  final Community community;
  final bool myCommunities;

  CommunityCard(
      {super.key, required this.community, required this.myCommunities});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  final CommunityService _communityService = CommunityService();

  void joinCommunity() async {
    Community community = widget.community;
    community.members = community.members + 1;
    await _communityService.joinCommunity(context, community);

    context.read<CommunityProvider>().community = community;
    context.go('/communities/home/${community.id}');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(context.read<UserProvider>().myCommunities.contains(widget.community)){
          context.read<CommunityProvider>().community = widget.community;
          context.go('/communities/home/${widget.community.name}');
        }
        else{
          showSnackBar(context, 'You aren\'t member of the community. \nPlease, join the community for visualize his contents');
        }

      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      '${widget.community.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                      width: 200,
                      height: 200,
                      child: Image.network(
                        widget.community.urlLogo,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(height: 8,),

                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('${widget.community.hotSpotAddress.city}'),
                    ],
                  ),
                  SizedBox(height: 8,),

                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.user,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('${widget.community.members} members'),
                    ],
                  ),/*
                  Positioned(
                      bottom: 8,
                      right: 8,
                      child: !widget.myCommunities
                          ? OutlinedButton(
                          onPressed: () {
                            joinCommunity();
                          },
                          child: Text('Join'))
                          : Center())
*/
                ],
              ),
            ),


        ),

    );
  }
}
