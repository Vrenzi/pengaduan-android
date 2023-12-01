import 'package:pengaduan/home_page.dart';
import 'package:pengaduan/screens/profilepage/account.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner:
          false, // Add this line to remove the debug label

      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
    ));

class MenusPage extends StatefulWidget {
  const MenusPage({super.key});

  @override
  State<MenusPage> createState() => _MenusPageState();
}

class _MenusPageState extends State<MenusPage> {
  @override
  int _selectedIndex = 0;

  static final List<Widget> _NavScreens = <Widget>[
    const UserAccount(),
    const HomePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _NavScreens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: Colors.pink,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GNav(
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            padding: const EdgeInsets.all(30),
            tabs: const [
              GButton(
                icon: Icons.account_circle,
                text: 'Profile',
              ),
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
