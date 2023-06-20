import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            buildPage(
              color: Colors.blueAccent,
              urlImage: 'assets/icons/Maham_next_slogan.png',
              title: 'text',
              subTitle: 'lorem ipsum',
            ),
            buildPage(
              color: Colors.blueAccent,
              urlImage: 'assets/icons/Maham_next_slogan.png',
              title: 'text',
              subTitle: 'lorem ipsum',
            ),
            buildPage(
              color: Colors.blueAccent,
              urlImage: 'assets/icons/Maham_next_slogan.png',
              title: 'text',
              subTitle: 'lorem ipsum',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);
                Navigator.of(context).pushReplacementNamed('/signup');
              },
              child: const Text('GET STARTED', style: TextStyle(fontSize: 24)),
            )
          : SizedBox(
              height: 80,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      controller.jumpToPage(2);
                    },
                    child: const Text('SKIP'),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.grey,
                        activeDotColor: Theme.of(context).hoverColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                          curve: Curves.easeInOut);
                    },
                    child: const Text('NEXT'),
                  ),
                ],
              ),
            ),
    );
  }

  buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subTitle,
  }) {}
}
