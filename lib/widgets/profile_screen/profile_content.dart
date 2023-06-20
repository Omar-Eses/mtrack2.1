import 'package:flutter/material.dart';
import 'package:mtrack/provider/home_view_model.dart';
import 'package:mtrack/provider/profile_view_model.dart';
import 'package:mtrack/screens/pages/profile_pages/edit_profile.dart';
import 'package:mtrack/widgets/custom_btn.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart'; // ask

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileViewModel>();
    final home = context.watch<HomeViewModel>();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(home.userModel!.image ?? ""),
            ),
            const SizedBox(height: 15),
            Text(
              '${home.userModel?.fName}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Computer Science',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 25,
                  lineWidth: 6,
                  percent: 0.05,
                  animation: true,
                  footer: const Text("Not Started"),
                  center: const Text("5%"),
                  backgroundColor: const Color.fromARGB(255, 129, 119, 119),
                  progressColor: const Color.fromARGB(255, 128, 182, 226),
                ),
                const SizedBox(width: 50),
                CircularPercentIndicator(
                  radius: 25,
                  lineWidth: 4,
                  percent: 0.8,
                  animation: true,
                  footer: const Text("In progress"),
                  center: const Text("80%"),
                  backgroundColor: const Color.fromARGB(255, 129, 119, 119),
                  progressColor: const Color.fromARGB(255, 128, 182, 226),
                ),
                const SizedBox(width: 50),
                CircularPercentIndicator(
                  radius: 25,
                  lineWidth: 4,
                  percent: 0.15,
                  animation: true,
                  footer: const Text("Finished"),
                  center: const Text("15%"),
                  backgroundColor: const Color.fromARGB(255, 129, 119, 119),
                  progressColor: const Color.fromARGB(255, 128, 182, 226),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 12.5),
            CustomButton(
              text: 'Edit Profile',
              width: 375,
              height: 50,
              icon: Icons.arrow_forward_ios,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(
                              userModel: home.userModel!,
                            )));
                // TODO navigate to profile file change f&l_name,title,bd
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Change Password',
              width: 375,
              height: 50,
              icon: Icons.arrow_forward_ios,
              onPressed: () {
                Navigator.pushNamed(context, '/change_pass');
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Settings',
              width: 375,
              height: 50,
              icon: Icons.arrow_forward_ios,
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Sign out',
              width: 375,
              height: 50,
              color: Colors.black,
              icon: Icons.arrow_forward_ios,
              onPressed: () {
                profile.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
