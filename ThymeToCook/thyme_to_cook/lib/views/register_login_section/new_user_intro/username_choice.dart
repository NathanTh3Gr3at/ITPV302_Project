import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thyme_to_cook/services/auth/user_provider.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/register_login_section/new_user_intro/ingredients_to_avoid.dart';

class UsernameChoiceView extends StatefulWidget {
  const UsernameChoiceView({super.key});

  @override
  State<UsernameChoiceView> createState() => _UsernameChoiceViewState();
}

class _UsernameChoiceViewState extends State<UsernameChoiceView> {
  TextEditingController usernameController = TextEditingController();
  bool _isUsernameValid = true;

  void _validateAndProceed() {
    if (usernameController.text.isEmpty) {
      setState(() {
        _isUsernameValid = false;
      });
    } else {
      Provider.of<UserProvider>(context, listen: false)
          .updateUsername(usernameController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const IngredientsToAvoidSelection(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: 1 / 4,
              backgroundColor: Color.fromARGB(255, 233, 233, 233),
              valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 162, 206, 100)),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "What is your name?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      errorText: !_isUsernameValid ? 'Please enter your name' : null,
                      errorStyle: const TextStyle(
                        color: errorMessagesAndAlertsColor,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0, left: 40, right: 40),
                child: ElevatedButton(
                onPressed: () {
                  _validateAndProceed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}