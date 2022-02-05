import 'package:flutter/material.dart';
import 'package:project_asn/blocs/sign_in_bloc.dart';
import 'package:project_asn/pages/login_page.dart';
import 'package:project_asn/utils/next_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          child: MaterialButton(
            color: Colors.blue,
            onPressed: () async {
              openLogoutDialog(context);
            },
            child: const Text(
              'logOut',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout From Application'),
            actions: [
              TextButton(
                child: const Text('NO'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<SignInBloc>().userSignout().then((value) =>
                      nextScreenCloseOthers(context, const LoginPage()));
                },
              )
            ],
          );
        });
  }
}
