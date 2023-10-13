import 'package:community_share/model/auth.dart';
import 'package:community_share/view/generic_components/SocialColors.dart';
import 'package:community_share/view/generic_components/social_widget_button.dart';
import 'package:community_share/view/login/components/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (error) {
      //settare errore
    }
  }

  Future<void> createUser() async {
    try {
      await Auth().createUserInWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (error) {
      //settare errore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: AppBar(
        title: Image.asset('assets/images/logo.jpg', fit: BoxFit.cover,),

      ),*/
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: WelcomeWidget()),
            SizedBox(
              height: 25.0,
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
                    ? ' Non hai un account? Registrati \n o \n accedi con:'
                    : 'Hai un account? Accedi',
                textAlign: TextAlign.center,
              ),
            ),
            SocialButtonWidgets.socialButtonRect('Login with Facebook',
                facebookColor, FontAwesomeIcons.facebookF, onTap: () {
              Fluttertoast.showToast(msg: 'I am Facebook');
            }),
            SocialButtonWidgets.socialButtonRect(
                'Login with Gmail', googleColor, FontAwesomeIcons.googlePlusG,
                onTap: () {
              Fluttertoast.showToast(msg: 'I am Google');
            }),
          ],
        ),
      ),
    ));
  }
}
