import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/view/community/components/events_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../service/community_service.dart';

class HomeCommunity extends StatefulWidget {
  const HomeCommunity({super.key});

  @override
  State<HomeCommunity> createState() => _HomeCommunityState();
}

class _HomeCommunityState extends State<HomeCommunity> {

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      await CommunityService().getEventsForCommunity(context);

    } catch (error) {
      // Gestisci l'errore in modo appropriato (ad esempio, mostra un messaggio di errore)
      print('Errore durante il recupero degli eventi: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme
          .of(context)
          .colorScheme
          .background,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context
                    .read<CommunityProvider>()
                    .community
                    .name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    context
                        .read<CommunityProvider>()
                        .community
                        .urlLogo,
                    width: 100,
                    height: 100,

                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.read<CommunityProvider>().community.type.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                        Text('Founder: ${context.read<CommunityProvider>().community.founder.fullName} ', style: TextStyle(fontSize: 16),),

                        Row(children: [
                          FaIcon(FontAwesomeIcons.locationDot, size: 16,),
                          SizedBox(width: 16,),
                          Text(context.read<CommunityProvider>().community.locationSite, style: TextStyle(fontSize: 16),)
                        ],),
                        Row(children: [
                          FaIcon(FontAwesomeIcons.users, size: 16,),
                          SizedBox(width: 8,),
                          Text('${context.read<CommunityProvider>().community.locationSite} members', style: TextStyle(fontSize: 16),)
                        ],),


                      ],
                    ),)
                ],
              ),
              SizedBox(height: 8,),
              Text('Description',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              Text(context.read<CommunityProvider>().community.description,style: TextStyle(fontSize: 16),),
              SizedBox(height: 12,),
              EventsList(),
            ],
          ),
        ),
      ),
    );
  }
}