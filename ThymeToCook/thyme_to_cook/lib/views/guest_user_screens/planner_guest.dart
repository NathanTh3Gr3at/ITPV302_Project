import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/register_login_section/login_view.dart';

class PlannerGuestView extends StatelessWidget {
  const PlannerGuestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navigationBarColor,
      appBar: AppBar(
        backgroundColor: navigationBarColor,
        automaticallyImplyLeading: false,
        title: const Text(
          "Meal Planner",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/sad_image.png'),
              height: 200, // Adjust height as needed
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Please log in to access the meal planner",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResponsiveWrapper.builder(
                              const LoginView(),
                              breakpoints: const [
                                ResponsiveBreakpoint.resize(480, name: MOBILE),
                                ResponsiveBreakpoint.resize(800, name: TABLET),
                                ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
                                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Text('Log In'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
