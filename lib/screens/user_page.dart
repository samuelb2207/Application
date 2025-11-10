import 'package:esme2526/domain/user_use_case.dart';
import 'package:esme2526/models/user.dart';
import 'package:esme2526/screens/home_page/home_page.dart';
import 'package:esme2526/screens/profile_widget.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserUseCase userUseCase = UserUseCase();
    User user = userUseCase.getUser();

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.deepPurple,
      ),
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex,
        onTap: (value) {
          print("Test BottomNavigationBar: $value");
          setState(() {
            _selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: 'Bets',
            icon: Icon(Icons.sports_esports),
          ),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return Center(child: Text('Bets'));
      case 2:
        // Pass the user object from build via a property or cache it
        UserUseCase userUseCase = UserUseCase();
        User user = userUseCase.getUser();
        return ProfileWidget(user: user);
      default:
        return Center(child: Text('Home'));
    }
  }
}
