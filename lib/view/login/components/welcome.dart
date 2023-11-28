import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.welcomeApp, style: WelcomeTextStyle.textStyle,textAlign: TextAlign.center,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

              children: [
            /*Text('C', style: LogoTextStyle.textStyle,),
            Image.asset('assets/images/logo_community_share.png', width: 40,height: 40,),*/
            Text('COMMUNITY SHARE', style: LogoTextStyle.textStyle,)
          ])
        ],
      ),
    );
  }
}

class LogoTextStyle {
  static const double fontSize = 25.0;
  static const FontWeight fontWeight = FontWeight.bold;

  static final TextStyle textStyle = TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    foreground: Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue.shade900,
          Colors.green,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
  );
}

class WelcomeTextStyle {
  static const double fontSize = 20.0;
  static const FontWeight fontWeight = FontWeight.bold;

  static const TextStyle textStyle = TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight
  );

}

