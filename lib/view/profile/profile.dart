import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/view/profile/components/intro_profile_with_photo.dart';
import 'package:community_share/view/profile/screen/password_change.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service/auth.dart';
import '../../utils/show_snack_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> signOut() async {
    try {
      await Auth().signOut();
      completeLogout();
    } catch (e) {
      callError(e.toString());
    }
  }

  void callError(String error) {
    showSnackBar(context, error, isError: true);
  }

  void completeLogout() {
    context.read<UserProvider>().clearAll();
    //context.go('/login');
  }

  Future<void> showPasswordChangeDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: PasswordChange(),
        );
      },
    );
  }
  void changeScreen(String route) {
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child: IntroProfile()),
          //Text('CONTRIBUTO SOCIALE', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          RowMenusProfile(
            label: AppLocalizations.of(context)!.profileMenuObject,
            label2: AppLocalizations.of(context)!.profileMenuObjectPartTwo,
            onTap: () {changeScreen('/profile/object_interactions');},
            icon: FontAwesomeIcons.handHoldingHeart,
          ),
          RowMenusProfile(
            label: AppLocalizations.of(context)!.orders,
            onTap:() {changeScreen('/profile/orders');},
            icon: FontAwesomeIcons.list,
          ),
          RowMenusProfile(
            label: AppLocalizations.of(context)!.communitiesOfUser,
            onTap: (){changeScreen('/profile/my_communities');},
            icon: FontAwesomeIcons.peopleGroup,
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'ACCOUNT',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)!.colorScheme.primary),
              )),

          RowMenusProfile(
            label: 'Impostazioni profilo',
            onTap:(){changeScreen('/profile/settings');} ,
            icon: FontAwesomeIcons.userGear,
          ),
          RowMenusProfile(
            label: 'Cambia password',
            onTap: ()async {
              await showPasswordChangeDialog();
            },
            icon: FontAwesomeIcons.key,
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'AIUTO, TERMINI E CONDIZIONI',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)!.colorScheme.primary),
              )),
          RowMenusProfile(
            label: 'Segnala un bug',
            onTap: (){},
            icon: FontAwesomeIcons.bug,
          ),
          RowMenusProfile(
            label: 'FAQ - Domande frequenti',
            onTap: (){},
            icon: FontAwesomeIcons.question,
          ),
          RowMenusProfile(
            label: 'Termini di utilizzo',
            onTap: (){},
            icon: FontAwesomeIcons.newspaper,
          ),
          RowMenusProfile(
            label: 'Informativa sulla privacy',
            onTap: (){},
            icon: FontAwesomeIcons.newspaper,
          ),
          //RowMenusProfile(label: 'paletta colori', icon: Icons.add, onTap:() {changeScreen('/profile/paletta_colori');}),
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            //color: Theme.of(context).colorScheme.tertiary,
            child: InkWell(
              onTap: () {
                signOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
/*                  const SizedBox(
                    width: 24,
                  ),*/
                  Text(
                    'Disconnetti',
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FaIcon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    size: 16,
                  ),
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
  final String? label2;
  final IconData icon;
  final VoidCallback onTap;


  const RowMenusProfile(
      {super.key,
      required this.label,
      //required this.route,
      required this.icon,
      this.label2,
      required this.onTap,
      });



  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onTap: onTap,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary,),
            const SizedBox(width: 8,),
            label2 == null
                ? Expanded(
                    child: Text(label,style: textStyle)
                  )
                : Expanded(
                    child: Row(
                      children: [
                        Text(label, style: textStyle),
                        Text(label2!, style: TextStyle(fontSize: 16))
                      ],),
                  ),
            const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
          ],
        ),
      ),
    );
  }
}
