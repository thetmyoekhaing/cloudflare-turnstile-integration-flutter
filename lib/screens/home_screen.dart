import 'package:cloudflare_recaptcha/screens/checkbox_captcha_screen.dart';
import 'package:cloudflare_recaptcha/screens/invisible_captcha_screen.dart';
import 'package:cloudflare_recaptcha/screens/non_interactive.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            {
              "name": "Checkbox Recaptcha Screen",
              "widget": const CheckboxCaptcha(),
            },
            {
              "name": "Invisible Recaptcha Screen",
              "widget": const InvisibleCaptcha(),
            },
            {
              "name": "Non Interactive Recaptcha Screen",
              "widget": const NonInteractiveCaptcha(),
            }
          ].map((widget) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return widget["widget"] as Widget;
                      },
                    ));
                  },
                  child: Text(
                    widget["name"].toString(),
                  )),
            );
          }).toList(),
        ),
      ),
    );
  }
}
