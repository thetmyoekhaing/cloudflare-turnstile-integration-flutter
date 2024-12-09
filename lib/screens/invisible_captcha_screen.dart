import 'package:cloudflare_recaptcha/.env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InvisibleCaptcha extends StatefulWidget {
  const InvisibleCaptcha({super.key});

  @override
  State<InvisibleCaptcha> createState() => _InvisibleCaptchaState();
}

class _InvisibleCaptchaState extends State<InvisibleCaptcha> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invisible CAPTCHA"),
      ),
      body: Stack(
        children: [
          // WebView for CAPTCHA
          InAppWebView(
            initialData: InAppWebViewInitialData(
              data: '''
              <!DOCTYPE html>
              <html>
              <head>
                <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit"></script>
              </head>
              <body>
                <!-- CAPTCHA container -->
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
                      sitekey: $invisibleSiteKey,
                      callback: onCaptchaSuccess,
                    });
                  }
                  
                  // Trigger CAPTCHA programmatically
                  function executeTurnstile() {
                    if (turnstileWidgetId !== null) {
                      turnstile.execute(turnstileWidgetId);
                    }
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

              // Adding a JavaScript handler to receive success tokens
              webViewController.addJavaScriptHandler(
                handlerName: 'onSuccess',
                callback: (args) {
                  final token = args.isNotEmpty ? args[0] : '';
                  debugPrint("CAPTCHA Success: $token");
                  // Handle the token here (e.g., send it to your backend)
                },
              );
            },
            onLoadStop: (controller, url) {
              debugPrint("WebView loaded: $url");
            },
          ),
          // Button to trigger CAPTCHA
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: triggerCaptcha,
              child: const Text("Verify"),
            ),
          ),
        ],
      ),
    );
  }

  // Function to trigger the CAPTCHA programmatically
  void triggerCaptcha() {
    webViewController.evaluateJavascript(source: "executeTurnstile();");
  }
}
