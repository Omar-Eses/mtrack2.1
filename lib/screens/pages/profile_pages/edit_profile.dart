import 'package:flutter/material.dart';
import 'package:mtrack/models/user_model.dart';
import 'package:mtrack/provider/home_view_model.dart';
import 'package:mtrack/widgets/custom_btn.dart';
import 'package:mtrack/widgets/custom_txt_form_field.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatelessWidget {
  final UserModel userModel;
  const EditProfile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final edit = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Form(
            key: edit.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: edit.image == null
                          ? NetworkImage(userModel.image!)
                          : FileImage(edit.image!) as ImageProvider,
                    ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              edit.getImage();
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelTxt: 'First Name',
                  controller: edit.fName,
                  fixedIcon: Icons.account_circle_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _firstName = value;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  labelTxt: 'Last Name',
                  fixedIcon: Icons.account_circle_outlined,
                  controller: edit.lName,
                  onSaved: (value) {
                    // _lastName = value;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  labelTxt: 'Title',
                  fixedIcon: Icons.account_circle_outlined,
                  onSaved: (value) {
                    // _title = value;
                  },
                ),
                const SizedBox(height: 15),
                edit.loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        text: 'Save Changes',
                        onPressed: () {
                          edit.updateUser(context, userModel);
                        },
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
