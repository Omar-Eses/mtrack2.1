import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mtrack/widgets/custom_btn.dart';
import 'package:mtrack/widgets/custom_txt_form_field.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/maham_above_slogan.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome Back... We missed You',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: auth.loginFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        labelTxt: 'Enter Email or Username',
                        fixedIcon: Icons.account_circle_outlined,
                        width: 250,
                        controller: auth.email,
                        validator: (value) {
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormField(
                        labelTxt: 'Enter Password',
                        fixedIcon: Icons.password,
                        isobscure: true,
                        width: 250,
                        controller: auth.password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is Empty";
                          } else if (value.length < 6) {
                            return "Password is Short";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomButton(
                        text: 'Log In',
                        onPressed: () async {
                          if (auth.loginFormKey.currentState!.validate()) {
                            await auth.login(context);
                            Navigator.pushNamed(context, '/home');
                          }
                        },
                        width: 250,
                        height: 50,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account? '),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    await auth.signInWithGoogle();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
