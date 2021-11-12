import 'package:currency_calculator/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CurvedNavBar.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _value;

  late Future<String> currencyPref;

  String currencySettingData = '';

  @override
  void initState() {
    super.initState();
    currencyPref = prefs.then((SharedPreferences prefs) {
      currencySettingData = (prefs.getString(currencyPrefKey) ?? 'usd');
      return currencySettingData;
    });
    getDataFromSharePref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: settingsUI(),
    );
  }

  settingsUI() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Currency"),
            Container(
              padding: EdgeInsets.all(20),
              child: DropdownButton(
                value: _value,
                items: featCurrencyId.map((String item) {
                  return DropdownMenuItem<String>(
                    child: Text(item),
                    value: item,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    setDataToSharePref(value);
                    print(_value);
                  });
                },
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Selected"),
            currencySettingData == null
                ? Text('')
                : Text('$currencySettingData')
          ],
        )
      ],
    );
  }

  Future<void> setDataToSharePref(data) async {
    final SharedPreferences mPrefs = await prefs;
    final String? mCurrencyPref = mPrefs.getString(currencyPrefKey);
    setState(() {
      currencyPref =
          mPrefs.setString(currencyPrefKey, data).then((bool success) {
        getDataFromSharePref();
        return currencyPref;
      });
    });
  }

  void getDataFromSharePref() async {
    final SharedPreferences mPrefs = await prefs;
    setState(() {
      currencySettingData = mPrefs.getString(currencyPrefKey)??"";
    });
  }
}
