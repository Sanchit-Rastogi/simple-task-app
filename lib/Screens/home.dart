import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/Provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _enabled = true;
  bool _checkLanguage = false;
  var url = 'http://165.22.19.126:4000/';
  List<Languages> langNames = [];

  void getData() async {
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    var names = data['languages'];
    for (var i in names) {
      langNames.add(Languages(name: i, isApplied: i == 'English' ? true : false));
    }
  }

  void unCheck(String name) {
    for (var i in langNames) {
      if (i.name != name) {
        setState(() {
          i.isApplied = false;
        });
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Task App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: _checkLanguage == false
            ? ListView(
                children: <Widget>[
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ListTile(
                    leading: Text('Darkmode'),
                    trailing: CupertinoSwitch(
                      value: _enabled,
                      onChanged: (value) {
                        setState(() {
                          _enabled = value;
                        });
                        _enabled ? _themeChanger.setTheme(ThemeData.dark()) : _themeChanger.setTheme(ThemeData.light());
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _enabled = !_enabled;
                      });
                    },
                  ),
                  ListTile(
                    leading: Text('Language'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      setState(() {
                        _checkLanguage = true;
                      });
                    },
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _checkLanguage = false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var lang = langNames[index];
                        return ListTile(
                          leading: Text(lang.name),
                          trailing: Checkbox(
                            value: lang.isApplied,
                            onChanged: (value) {
                              setState(() {
                                lang.isApplied = value;
                              });
                              unCheck(lang.name);
                            },
                          ),
                        );
                      },
                      itemCount: langNames.isEmpty ? 0 : langNames.length,
                    ),
                  )
                ],
              ),
      ),
      body: Center(
        child: Material(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.redAccent,
                width: 5,
              ),
            ),
            child: Text(
              'Hello World',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Languages {
  String name;
  bool isApplied;

  Languages({this.name, this.isApplied});
}
