import 'package:community_share/main.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/view/community/screen/community_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CommunityCard extends StatelessWidget{
  late Community community;


  CommunityCard(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.go('/communities/home/${community.name}',extra: community);
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
                      Text('${community.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.locationPin, size: 16,),
                          Text('${community.locationSite}'),
                        ],
                      ),
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.typo3, size: 16,),
                          Text('${community.type}'),
                        ],
                      ),
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.users, size: 16,),
                          Text(' members'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )

      ),
    );
  }
}