import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:webview_flutter/webview_flutter.dart';


class StripePaymentScreen extends StatefulWidget {
  const StripePaymentScreen(this.url, {super.key});

  final String url;

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://productiq-api.wemofy.in/api/v1/subscription/success')) {
              MyConsts.isPurchased = true;
              GoRouter.of(context).pushNamed(MyAppRouteConst.paymentSuccessRoute);
            }
            if(request.url.startsWith('https://productiq-api.wemofy.in/api/v1/subscription/failure')) {
              GoRouter.of(context).pushNamed(MyAppRouteConst.paymentFailureRoute);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
