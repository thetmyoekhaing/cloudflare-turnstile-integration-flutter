import 'package:cloudflare_recaptcha/.env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CheckboxCaptcha extends StatefulWidget {
  const CheckboxCaptcha({super.key});

  @override
  State<CheckboxCaptcha> createState() => _CheckboxCaptchaState();
}

class _CheckboxCaptchaState extends State<CheckboxCaptcha> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkbox CAPTCHA")),
      body: Center(
        child: InAppWebView(
          initialData: InAppWebViewInitialData(
            data: '''
          <!DOCTYPE html>
          <html>
          <head>
             <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit"></script>
          </head>
          <body>
             <div id="cf-turnstile"></div>
             <script>
               function onCaptchaSuccess(token) {
                 window.flutter_inappwebview.callHandler('onSuccess', token);
               }
               turnstile.ready(function () {
                 if (!document.getElementById('cf-turnstile').hasChildNodes()) {
                   turnstile.render('#cf-turnstile', {
                     sitekey: $checkboxSiteKey,
                     callback: function (token) {
                       window.flutter_inappwebview.callHandler('onSuccess', token);
                     }
                   });
                 }
               });
             </script>
          </body>
          </html>
          ''',
            baseUrl: WebUri("http://localhost/"),
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;

            // Add JavaScript handler
            webViewController.addJavaScriptHandler(
              handlerName: 'onSuccess',
              callback: (args) {
                final token = args.isNotEmpty ? args[0] : '';
                debugPrint('Captcha success: $token');
              },
            );
          },
        ),
      ),
    );
  }
}
