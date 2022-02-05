import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:project_asn/blocs/sign_in_bloc.dart';
import 'package:project_asn/pages/home.dart';
import 'package:project_asn/utils/constans.dart';
import 'package:project_asn/utils/next_screen.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  final String number;
  const Registration({Key? key, required this.number}) : super(key: key);

  @override
  _RegistrationState createState() {
    return _RegistrationState();
  }
}

class _RegistrationState extends State<Registration> {
  bool verify = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? _enteredOTP;

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.read<SignInBloc>();
    final String _phoneNumber = "+62" + widget.number;
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: _phoneNumber,
        timeOutDuration: const Duration(seconds: 60),
        onLoginSuccess: (userCredential, autoVerified) async {
          _showSnackBar(
            context,
            'Phone number verified successfully!',
          );
          print(autoVerified
              ? "OTP was fetched automatically"
              : "OTP was verified manually");

          print("Login Success UID: ${userCredential.user?.uid}");
          sb.setSignIn().then((value) {
            setState(() => verify = false);
            nextScreenCloseOthers(context, Home());
          });
        },
        onLoginFailed: (authException) {
          print("An error occurred: ${authException.message}");
          _showSnackBar(
            context,
            'Something went wrong (${authException.message})',
          );
          setState(() => verify = true);
          // handle error further if needed
        },
        builder: (context, controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Verification Code"),
              backgroundColor: Colors.black,
              actions: [
                if (controller.codeSent)
                  TextButton(
                    child: Text(
                      controller.timerIsActive
                          ? "${controller.timerCount.inSeconds}s"
                          : "RESEND",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: controller.timerIsActive
                        ? null
                        : () async => await controller.sendOTP(),
                  ),
                const SizedBox(width: 5),
              ],
            ),
            body: controller.codeSent
                ? ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Image(
                          image: AssetImage('assets/otp.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      const Text(
                        "Verify Your Number",
                        style: Constants.BoldHeading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Please enter the verification code sent to your number $_phoneNumber",
                        style: Constants.regularHeading2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: controller.timerIsActive ? null : 0,
                        child: Column(
                          children: const [
                            CircularProgressIndicator.adaptive(),
                            SizedBox(height: 50),
                            Text(
                              "Listening for OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Divider(),
                            Text("OR", textAlign: TextAlign.center),
                            Divider(),
                          ],
                        ),
                      ),
                      const Text(
                        "Enter OTP",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextField(
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        onChanged: (String v) async {
                          _enteredOTP = v;
                          if (_enteredOTP?.length == 6) {
                            final isValidOTP = await controller.verifyOTP(
                              otp: _enteredOTP!,
                            );
                            // Incorrect OTP
                            if (!isValidOTP) {
                              _showSnackBar(
                                context,
                                "Please enter the correct OTP sent to $_phoneNumber",
                              );
                            }
                          }
                        },
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator.adaptive(),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          "Sending OTP",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
