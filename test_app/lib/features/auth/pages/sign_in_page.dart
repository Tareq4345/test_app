
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/components/custom_button.dart';
import 'package:test_app/components/custom_text_fields.dart';
import 'package:test_app/features/auth/controller/auth_controller.dart';


class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState()  => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  final _signInKey = GlobalKey<FormState>();


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

Future<void> signInWithGoogle(BuildContext context) async {
  
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
          // Navigator.push(
          //    context,
          //    MaterialPageRoute(
          //      builder: (context) => const UserPage(),
          //     ),
          //  );
    
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        primary: true,
        physics: const BouncingScrollPhysics(),
        child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                child: Form(
                  key: _signInKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(controller: _emailController, label: "Email",),
                      const SizedBox(height: 15,),
                      CustomTextField(controller: _passwordController, label: "Password",),
                      const SizedBox(height: 15,),
                      CustomButton(text: 'SignIn', onPressed:_signIn,),
                      const SizedBox(height: 15,),
                      TextButton(onPressed:() =>signInWithGoogle(context),
                      child: const Text("Login With Google"),),
                    ],
                  ),
                ),
              ),
        
          ],
        ),
      ),
    );
  
  
  }

  _signIn(){

  }
}

