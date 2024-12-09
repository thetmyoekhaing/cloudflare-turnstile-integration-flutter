import 'package:cloudflare_recaptcha/.env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NonInteractiveCaptcha extends StatefulWidget {
  const NonInteractiveCaptcha({super.key});

  @override
  State<NonInteractiveCaptcha> createState() => _NonInteractiveCaptchaState();
}

class _NonInteractiveCaptchaState extends State<NonInteractiveCaptcha> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Non-Interactive CAPTCHA"),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: '''
              <!DOCTYPE html>
              <html>
              <head>
                <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit"></script>
              </head>
              <body>
                <div id="cf-turnstile" style="display:none;"></div>
                
                <script>
                  console.log("calling")
                 
                  let turnstileWidgetId = null;

                  // Success callback to send token to Flutter
                  function onCaptchaSuccess(token) {
                    window.flutter_inappwebview.callHandler('onSuccess', token);
                  }

                  // Initialize Turnstile widget on page load
                  function renderTurnstile() {
                    turnstileWidgetId = turnstile.render('#cf-turnstile', {
                      sitekey: $nonInteractiveSiteKey,
                      callback: onCaptchaSuccess,
                    });
                  }
                  

                  document.addEventListener("DOMContentLoaded", renderTurnstile);
                </script>
              </body>
              </html>
              ''',
          baseUrl: WebUri("http://localhost/"),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;

          // Adding a JavaScript handler to receive the success token
          webViewController.addJavaScriptHandler(
            handlerName: 'onSuccess',
            callback: (args) {
              final token = args.isNotEmpty ? args[0] : '';
              debugPrint("CAPTCHA Success Token: $token");
              // Handle the token (e.g., send it to your backend)
            },
          );
        },
        onLoadStop: (controller, url) {
          debugPrint("WebView loaded: $url");
        },
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint("Console Message: ${consoleMessage.message}");
        },
      ),
    );
  }
}
