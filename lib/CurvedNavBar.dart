import 'package:currency_calculator/screens/fw_cards.dart';
import 'package:currency_calculator/screens/home.dart';
import 'package:currency_calculator/screens/wallet.dart';
import 'package:currency_calculator/utilities/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utilities/dev.log.dart';
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  bool _initialized = false;
  bool _error = false;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  int selectedpage = 0; //initial value

  final _pageOptions = [
    const FWCards(),
    const Home(),
    const Wallet(),
  ]; // listing of all 3 pages index wise

  final bgcolor = [Colors.orange, Colors.pink, Colors.greenAccent];
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Loading();
    }
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.wallet_membership, size: 30),
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
          children: <Widget>[
            FWCards(),
            Wallet(),
            Home(),
          ],
        ),
      ),
      // body: _pageOptions[selectedpage],
    );
  }

  Widget SomethingWentWrong() {
    Dev.debug("Firebase initialization failed");
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(child: Text("Firebase initialization failed")),
      ),
    );
  }

  Widget Loading() {
    return getCircularProgressIndicator(30);
  }
}
