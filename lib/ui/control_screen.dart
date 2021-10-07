import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/ui/home_screen.dart';
import 'package:watchmovie/ui/search.dart';

class ControllScreen extends StatefulWidget {
  const ControllScreen({Key? key}) : super(key: key);

  @override
  _ControllScreenState createState() => _ControllScreenState();
}

class _ControllScreenState extends State<ControllScreen> {

  int _selectedIndex = 0;



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final List<Widget> _widgetOptions = [
    HomeScreen(),
     SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:_widgetOptions.elementAt(_selectedIndex) ,
        bottomNavigationBar:BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                title: Text('Home',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'muli'),),
                icon: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(Icons.home,)
                )),
            BottomNavigationBarItem(
                title: Text('Search',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'muli'),),
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.search,)
                )),

          ],
          currentIndex: _selectedIndex,
          elevation: 0,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          backgroundColor: Color(0xFF1D1D28),
          onTap: _onItemTapped
        ) ,
      );
  }
}
