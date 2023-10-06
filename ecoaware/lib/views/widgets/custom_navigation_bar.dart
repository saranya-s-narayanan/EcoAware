import 'package:ecoaware/utils/constants.dart';
import 'package:ecoaware/views/home_screen.dart';
import 'package:ecoaware/views/profile_screen.dart';
import 'package:ecoaware/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomNavigationBar extends StatefulWidget {
   int currentIndex;

  CustomNavigationBar({
     required this.currentIndex,
  });

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Theme(

      data: Theme.of(context).copyWith(
        // Customize active tab background color
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Constants().greenColor,
         // selectedIconTheme: IconThemeData(size: 24),
         // selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
         // backgroundColor: Colors.white,
        ),
        // Customize label text color
        //textTheme: Theme.of(context).textTheme.copyWith(
          //caption: TextStyle(color: Colors.black),
        //),
      ),

      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (int index) {
          setState(() {
            widget.currentIndex = index;
          });

          if (index == 0) {
            // Navigate to home page
            print('home tapped: ${context} |');
             Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => HomeScreen()),
             );
          } else if (index == 1) {
            // Navigate to profile page
            print('profile tapped');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }else if (index == 2) {
            // Navigate to profile page
            print('settings tapped');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppLocalizations.of(context)?.profile ?? 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppLocalizations.of(context)?.settings ?? 'Settings',
          ),
        ],
      ),
    );
  }
}
