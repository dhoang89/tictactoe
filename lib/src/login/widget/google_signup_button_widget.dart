import 'package:flutter/material.dart';
import 'package:flutter/src/material/elevated_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tictactoe/src/login/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleSignupButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () {
            final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
          child: Text('Sign In With Google'),
        )


        // )

        // OutlinedButton.icon(
        //   label: Text(
        //     'Sign In With Google',
        //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        //   ),
        //   shape: StadiumBorder(),
        //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //   highlightedBorderColor: Colors.black,
        //   borderSide: BorderSide(color: Colors.black),
        //   textColor: Colors.black,
        //   icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
        //   onPressed: () {
        //     final provider =
        //         Provider.of<GoogleSignInProvider>(context, listen: false);
        //     provider.login();
        //   },
        // ),
      );
}
