import 'package:flutter/material.dart';
import 'package:project_2/view/ProductsListScreen.dart';
import 'package:project_2/view/users_list_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens to switch between
  static final List<Widget> _screens = <Widget>[
    UsersListScreen(),
    ProductsListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Người Dùng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Sản Phẩm',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
