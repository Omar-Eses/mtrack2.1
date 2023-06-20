import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mtrack/widgets/custom_txt_form_field.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_view_model.dart';
import '../../widgets/custom_btn.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      body: Center(
        heightFactor: 20,
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/maham_above_slogan.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Form(
                    key: auth.registerFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          labelTxt: 'Enter Email',
                          fixedIcon: Icons.email_outlined,
                          width: 250,
                          controller: auth.registerEmail,
                          validator: (value) {
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelTxt: 'Enter First name',
                          fixedIcon: Icons.account_circle_outlined,
                          controller: auth.fName,
                          width: 250,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "first Name is Empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelTxt: 'Enter Last name',
                          fixedIcon: Icons.account_circle_outlined,
                          controller: auth.lName,
                          width: 250,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "last Name is Empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelTxt: 'Enter Password',
                          fixedIcon: Icons.password_outlined,
                          width: 250,
                          isobscure: true,
                          controller: auth.registerPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password is Empty";
                            } else if (value.length < 6) {
                              return "Password is Short";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelTxt: 'Confirm Password',
                          fixedIcon: Icons.password_sharp,
                          width: 250,
                          isobscure: true,
                          controller: auth.registerConfirmPassword,
                          validator: (value) {
                            if (value != auth.registerPassword.text) {
                              return "Password not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        auth.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CustomButton(
                                text: 'Sign Up',
                                onPressed: () async {
                                  if (auth.registerFormKey.currentState!
                                      .validate()) {
                                    await auth.registerUser(context);
                                  }
                                },
                                width: 250,
                                height: 50,
                              ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Have an account? '),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Back to Log In'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight:
                                  FontWeight.bold // Adjust the color as needed
                              ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey, // Adjust the color as needed
                          thickness: 1, // Adjust the thickness as needed
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        await auth.signInWithGoogle();
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
