import 'package:community_share/service/auth.dart';
import 'package:community_share/utils//show_snack_bar.dart';
import 'package:community_share/view/generic_components/SocialColors.dart';
import 'package:community_share/view/generic_components/social_widget_button.dart';
import 'package:community_share/view/login/components/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLogin = true;
  bool hidePassword = true;

  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _email.text, password: _password.text, context: context);
      if(Auth().currentUser != null){
        context.go('/');
      }
/*      if(Auth().currentUser!.emailVerified) {
        context.go('/');
      } else{
        showSnackBar(context, 'Check your email and confirm your email adress!');
      }*/
    } on FirebaseAuthException catch (error) {
      print('entro nell\'error');
      callError(error.message!);
    }
  }

  Future<void> createUser() async {
    try {
      await Auth().createUserInWithEmailAndPassword(
          email: _email.text, password: _password.text, context: context);
    } on FirebaseAuthException catch (error) {
      showSnackBar(context, error.message!);
    }
  }
  
  Future<void> signInWithGmail()async{
    try{
      await Auth().signInWithGoogle(context);

    }on FirebaseAuthException catch (e){
      print(e.message!);
    }
  }

  Future<void> signInWithFacebook() async{
    await Auth().signInWithFacebook(context);
  }

  void callError(String error){
    showSnackBar(context, error,isError: true);

  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: WelcomeWidget()),
            SizedBox(
              height: 30.0,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 50.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                  minHeight: 50.0,
                  maxHeight: 50.0),
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                        borderRadius: BorderRadius.circular(10.0)),
                    label: Text('email')),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 50.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                  minHeight: 50.0,
                  maxHeight: 50.0),
              child: TextField(
                controller: _password,
                obscureText: hidePassword,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                        borderRadius: BorderRadius.circular(10.0)),
                    label: Text('password'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    )),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            OutlinedButton(
                onPressed: () {
                  isLogin ? signIn() : createUser();
                },
                child: Text(isLogin
                    ? AppLocalizations.of(context)!.signin
                    : AppLocalizations.of(context)!.signup)),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin
                    ? AppLocalizations.of(context)!.notHaveAnAccount
                    : AppLocalizations.of(context)!.haveAnAccount,
                textAlign: TextAlign.center,
              ),
            ),
            SocialButtonWidgets.socialButtonRect(AppLocalizations.of(context)!.signInFacebook,
                facebookColor, FontAwesomeIcons.facebookF, onTap: () {
              signInWithFacebook();
            }),
            SocialButtonWidgets.socialButtonRect(
                AppLocalizations.of(context)!.signInGmail, googleColor, FontAwesomeIcons.googlePlusG,
                onTap: () {
              signInWithGmail();
            }),
          ],
        ),
      ),
    ));
  }
}
