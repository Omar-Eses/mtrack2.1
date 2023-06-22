import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mtrack/firebase_options.dart';
import 'package:mtrack/helper/cache_helper.dart';
import 'package:mtrack/provider/add_member_view_model.dart';
import 'package:mtrack/provider/auth_view_model.dart';
import 'package:mtrack/provider/edit_profile_view_model.dart';
import 'package:mtrack/provider/home_view_model.dart';
import 'package:mtrack/provider/profile_view_model.dart';
import 'package:mtrack/provider/task_view_model.dart';
import 'package:mtrack/provider/team_view_model.dart';
import 'package:mtrack/provider/theme_view_model.dart';
import 'package:mtrack/screens/authentication/login.dart';
import 'package:mtrack/screens/authentication/signup.dart';
import 'package:mtrack/screens/pages/home_pages/home.dart';
import 'package:mtrack/screens/pages/notifications.dart';
import 'package:mtrack/screens/pages/profile_pages/change_pass.dart';
import 'package:mtrack/screens/pages/profile_pages/profile.dart';
import 'package:mtrack/screens/pages/profile_pages/settings.dart';
import 'package:mtrack/screens/pages/teams_pages/add_member.dart';
import 'package:mtrack/screens/pages/teams_pages/create_team_form.dart';
import 'package:mtrack/screens/pages/teams_pages/manage_members.dart';
import 'package:mtrack/screens/pages/teams_pages/teams_screen.dart';
import 'package:mtrack/screens/pages/teams_pages/view_members.dart';
import 'package:mtrack/screens/wrapper.dart';
import 'package:mtrack/theme_settings.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final prefs = await SharedPreferences.getInstance();
  // final showHome = prefs.getBool('showHome') ?? false;
  await CacheHelper.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MahamApp(),
    ),
  );
}

class MahamApp extends StatefulWidget {
  const MahamApp({Key? key}) : super(key: key);

  @override
  State<MahamApp> createState() => _MahamAppState();
}

class _MahamAppState extends State<MahamApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => TeamViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeSettings()),
        ChangeNotifierProvider(create: (_) => AddMemberViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
      ],
      child: MaterialApp(
        home: const Wrapper(),
        debugShowCheckedModeBanner: false,
        title: 'Maham Tracking',
        theme: lightTheme,
        routes: {
          '/signup': ((context) => const SignUpPage()),
          '/login': ((context) => const LoginPage()),
          '/home': ((context) => const HomeScreen()),
          '/teams': ((context) => TeamsScreen()),
          '/profile': ((context) => const ProfileScreen()),
          '/notifications': ((context) => const NotificationsPage()),
          // '/team': ((context) => const TeamScreen()),
          // '/task': ((context) => TaskScreen(tas)),
          // '/edit_profile': ((context) => const EditProfile()),
          '/change_pass': ((context) => const ChangePass()),
          '/settings': ((context) => const SettingsPage()),
          '/new_team': ((context) => const CreateTeamForm()),
          '/add_member': ((context) => const AddMember()),
          '/mng_team_members': ((context) => const ManageTeamMembers()),
          // '/new_task': ((context) => contextonst CreateTaskForm()),
          '/view_team_members': ((context) => const ViewTeamMembers()),
        },
      ),
    );
  }
}

final darkTheme = ThemeData(
  // Customize the dark theme colors and styles here
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 9, 58, 82),
  ),
);
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 9, 58, 82),
  ),
);
