import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/view/profile/components/intro_profile_with_photo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../service/auth.dart';
import '../../utils/show_snack_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {



  Future<void> signOut() async {
    try{
      await Auth().signOut();
      completeLogout();
    }catch (e){
      callError(e.toString());
    }


  }

  void callError(String error) {
    showSnackBar(context, error, isError: true);
  }

  void completeLogout(){
    context.read<UserProvider>().clearAll();
    //context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: IntroProfile()),
          //Text('CONTRIBUTO SOCIALE', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          RowMenusProfile(
            label: 'Oggetti donati',
            route: '/profile/donated_products',
            icon: FontAwesomeIcons.handHoldingHeart,
          ),
          RowMenusProfile(
            label: 'Oggetti ricevuti',
            route: '/profile/received_products',
            icon: FontAwesomeIcons.heartPulse,
          ),
          RowMenusProfile(
            label: 'Lista Necessità',
            route: '/profile/needed_products',
            icon: FontAwesomeIcons.magnifyingGlass,
          ),
          RowMenusProfile(
            label: 'Orders',
            route: '/profile/orders',
            icon: FontAwesomeIcons.list,
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'ACCOUNT',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),

          RowMenusProfile(
            label: 'Impostazioni profilo',
            route: '/profile/settings',
            icon: FontAwesomeIcons.userGear,
          ),
          RowMenusProfile(
            label: 'Cambia password',
            route: '/profile/password_change',
            icon: FontAwesomeIcons.key,
          ),
/*          RowMenusProfile(
            label: 'Indirizzo-hub spedizione',
            route: '/profile/addresses',
            icon: FontAwesomeIcons.locationDot,
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'AIUTO',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          RowMenusProfile(
            label: 'Segnala un bug',
            route: '',
            icon: FontAwesomeIcons.bug,
          ),
          RowMenusProfile(
            label: 'FAQ - Domande frequenti',
            route: '',
            icon: FontAwesomeIcons.question,
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'TERMINI E CONDIZIONI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          RowMenusProfile(
            label: 'Termini di utilizzo',
            route: '',
            icon: FontAwesomeIcons.newspaper,
          ),
          RowMenusProfile(
            label: 'Informativa sulla privacy',
            route: '',
            icon: FontAwesomeIcons.newspaper,
          ),*/
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            //color: Theme.of(context).colorScheme.tertiary,
            child: InkWell(
              onTap: () {
                signOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                      child: Text(
                    'Disconnetti',
                    style: const TextStyle(fontSize: 20),
                  )),
                  FaIcon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          Container(color: Colors.yellow, child: Row()),
          Container(
            color: Theme.of(context).colorScheme.tertiary,
            child: InkWell(
              onTap: () {
                context.go('/profile/paletta_colori');
              },
              child: Row(
                children: [
                  Text(
                    'PALETTA COLORI TEMA',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RowMenusProfile extends StatelessWidget {
  final String label;
  final String route;
  final IconData icon;

  const RowMenusProfile(
      {super.key,
      required this.label,
      required this.route,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      //color: Theme.of(context).colorScheme.tertiary,
      child: InkWell(
        onTap: () {
          context.go(route);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 16,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(
              label,
              style: const TextStyle(fontSize: 20),
            )),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
