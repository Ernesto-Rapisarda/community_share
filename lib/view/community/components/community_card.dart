import 'package:community_share/main.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/view/community/screen/community_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/UserProvider.dart';

class CommunityCard extends StatefulWidget{
  late Community community;

  CommunityCard(this.community, {super.key});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  final CommunityService _communityService = CommunityService();

  void joinCommunity() async{
    await _communityService.joinCommunity(context,widget.community);
    context.read<CommunityProvider>().community = widget.community;
    context.go('/communities/home/${widget.community.name}');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.read<CommunityProvider>().community = widget.community;
        context.go('/communities/home/${widget.community.name}');
      },
      child: Card(
          elevation: 3,
          margin: EdgeInsets.all(10),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.asset('assets/images/chiesa_nocera.jpg',fit: BoxFit.cover,),
                  Column(
                    children: [
                      Text('${widget.community.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.locationPin, size: 16,),
                          Text('${widget.community.locationSite}'),
                        ],
                      ),
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.typo3, size: 16,),
                          Text('${widget.community.type}'),
                        ],
                      ),
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.users, size: 16,),
                          Text(' members'),
                        ],
                      ),
                      Auth().currentUser?.uid != widget.community.founder.id && !context.read<UserProvider>().myCommunities.contains(widget.community)
                          ? OutlinedButton(
                            onPressed: (){
                              joinCommunity();
                            }, child: Text('Join'))
                      : Center()


                    ],
                  ),

                ],
              ),
            ),
          )

      ),
    );
  }
}