import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget{
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text('CONTRIBUTO SOCIALE', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          RowMenusProfile(label: 'Oggetti donati', route: '', icon: FontAwesomeIcons.list,),
          RowMenusProfile(label: 'Oggetti ricevuti', route: '',icon: FontAwesomeIcons.listCheck,),
          RowMenusProfile(label: 'Lista Necessità', route: '',icon: FontAwesomeIcons.magnifyingGlass,),
          RowMenusProfile(label: 'Donazioni', route: '',icon: FontAwesomeIcons.handHoldingHeart,),
          Text('ACCOUNT', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          RowMenusProfile(label: 'Notifiche', route: '',icon: FontAwesomeIcons.bell,),
          RowMenusProfile(label: 'Impostazioni profilo', route: '',icon: FontAwesomeIcons.userGear,),
          RowMenusProfile(label: 'Cambia e-mail', route: '',icon: FontAwesomeIcons.envelope,),
          RowMenusProfile(label: 'Cambia password', route: '',icon: FontAwesomeIcons.key,),
          RowMenusProfile(label: 'Indirizzo-hub spedizione', route: '',icon: FontAwesomeIcons.locationDot,),
          Text('AIUTO', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          RowMenusProfile(label: 'Segnala un bug', route: '', icon: FontAwesomeIcons.bug,),
          RowMenusProfile(label: 'FAQ - Domande frequenti', route: '',icon: FontAwesomeIcons.question,),
          Text('TERMINI E CONDIZIONI', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          RowMenusProfile(label: 'Termini di utilizzo', route: '',icon: FontAwesomeIcons.newspaper,),
          RowMenusProfile(label: 'Informativa sulla privacy', route: '',icon: FontAwesomeIcons.newspaper,),
          RowMenusProfile(label: 'Disconnetti', route: '',icon: FontAwesomeIcons.newspaper,),

          Container(
              color: Colors.yellow,
              child: Row()),
          Container(
            color: Theme.of(context).colorScheme.tertiary,
            child: InkWell(onTap: (){context.go('/profile/paletta_colori');},
              child: Row(
                children: [
                  Text('PALETTA COLORI TEMA',style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class RowMenusProfile extends StatelessWidget{
  final String label;
  final String route;
  final IconData icon;

  const RowMenusProfile({super.key, required this.label, required this.route, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      //color: Theme.of(context).colorScheme.tertiary,
      child: InkWell(onTap: (){context.go(route);},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 16, ),
            const SizedBox(width: 8,),
            Expanded(
                child: Text(label, style: const TextStyle(fontSize: 20),)),
            const FaIcon(FontAwesomeIcons.chevronRight, size: 16,),
          ],
        ),
      ),
    );
  }




}