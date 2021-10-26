import 'package:currency_calculator/screens/fw_cards.dart';
import 'package:currency_calculator/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedpage = 0; //initial value

  final _pageOptions = [
    const FWCards(),
    const Home(),
  ]; // listing of all 3 pages index wise

  final bgcolor = [Colors.orange, Colors.pink, Colors.greenAccent];
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.apps_sharp, size: 30),


          // Icon(Icons.compare_arrows, size: 30),
          // Icon(Icons.call_split, size: 30),
          // Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.black12,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            selectedpage = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: Colors.blueAccent,
        child: IndexedStack(
          index: selectedpage,
          children: <Widget>[FWCards(),Home(), ],
        ),
      ),
      // body: _pageOptions[selectedpage],
    );
  }
}
