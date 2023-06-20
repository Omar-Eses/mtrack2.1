import 'package:flutter/material.dart';
import 'package:mtrack/provider/auth_view_model.dart';
import 'package:mtrack/widgets/custom_btn.dart';
import 'package:mtrack/widgets/custom_txt_form_field.dart';
import 'package:provider/provider.dart';

class ChangePass extends StatelessWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/reset_pass.png'),
                        fit: BoxFit.scaleDown,
                      )),
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  labelTxt: 'Enter your old password',
                  fixedIcon: Icons.account_circle_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the old password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _firstName = value;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  labelTxt: 'Enter new password',
                  fixedIcon: Icons.account_circle_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _lastName = value;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  labelTxt: 'Confirm new password',
                  fixedIcon: Icons.account_circle_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is wrong';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _title = value;
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: 'Save Changes',
                  onPressed: () {},
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
