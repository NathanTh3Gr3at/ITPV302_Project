import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/themes/colors/colors.dart';
import 'package:thyme_to_cook/views/main_navigation.dart';

class OpenAppView extends StatefulWidget {
  const OpenAppView({super.key});
  
  @override
  State<OpenAppView> createState() => _OpenAppViewState();
}

class _OpenAppViewState extends State<OpenAppView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: openAppBackgroundColor,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: ResponsiveRowColumn(
          layout: ResponsiveWrapper.of(context).isSmallerThan('4K')
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
          children: [
            const ResponsiveRowColumnItem(
              child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Image(
                  image: AssetImage('assets/images/thyme_to_cook_logo.png'),
                  width: 350,
                  height: 350,
                ),
              ),
            ),
            ),
            ResponsiveRowColumnItem(
              child: Align(
              alignment: Alignment.center,
              child: RichText(
                text: const TextSpan(
                  text: 'Welcome',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            ),
            ResponsiveRowColumnItem(
              child: Padding(
              padding: const EdgeInsets.only(top:250,bottom:40, left: 18, right: 18),
              child: ElevatedButton(
                // Guest user !!
                onPressed: () {
                   context.read<AuthBloc>().add(
                      const AuthEventGuestUser(),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(isLoggedIn: false,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButtonColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text(
                    'Lets start cooking',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(MdiIcons.arrowRight,)
                  ]
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
