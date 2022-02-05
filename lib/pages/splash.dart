import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_asn/blocs/sign_in_bloc.dart';
import 'package:project_asn/pages/home.dart';
import 'package:project_asn/pages/login_page.dart';
import 'package:project_asn/utils/next_screen.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  afterSplash() {
    final SignInBloc sb = context.read<SignInBloc>();
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      sb.isSignedIn == true ? gotoHomePage() : gotoSignInPage();
    });
  }

  gotoHomePage() {
    //final SignInBloc sb = context.read<SignInBloc>();
    nextScreenReplace(context, const Home());
  }

  gotoSignInPage() {
    nextScreenReplace(context, const LoginPage());
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    animation = CurvedAnimation(curve: Curves.easeIn, parent: _controller);
    _controller.forward();
    afterSplash();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FadeTransition(
        opacity: animation,
        child: const Image(
          image: AssetImage('assets/otp.png'),
          height: 300,
          width: 300,
          fit: BoxFit.contain,
        ),
      )),
    );
  }
}
