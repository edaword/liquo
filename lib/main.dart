import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'water demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('erRor: ${snapshot.error.toString()}');
            return Text('some error!');
          } else if (snapshot.hasData) {
            return MyHomePage(title: 'water demo');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // home: MyHomePage(title: 'water demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _database = FirebaseDatabase.instance.reference();
  // StreamSubscription _nameStream;
  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    /////////////////////////////////////////////////change userid
    final String _userid = 'userid_aaa';
    final path = 'users/$_userid';
    // final _userRef = _database.child('users/$_userid');

    //name
    _database.child('$path/name').onValue.listen((event) {
      final String _userName = event.snapshot.value;
      setState(() {
        _name = _userName;
      });
    });

    //oxygen
    _database.child('$path/oxygen').onValue.listen((event) {
      final int _userOxygen = event.snapshot.value;
      setState(() {
        _oxygen = _userOxygen;
      });
    });

    //turbidity
    _database.child('$path/turbidity').onValue.listen((event) {
      final int _userTurbidity = event.snapshot.value;
      setState(() {
        _turbidity = _userTurbidity;
      });
    });

    //capacity
    _database.child('$path/capacity').onValue.listen((event) {
      final int _userCapacity = event.snapshot.value;
      setState(() {
        _capacity = _userCapacity;
      });
    });
  }

  String _name = "";
  int _oxygen = 0;
  int _turbidity = 0;
  int _capacity = 0;
  int _time = 0;
  // double _oxygen = 0.0;
  // double _turbidity = 0.0;
  // double _capacity = 0.0;
  // double _time = 0.0;

  void _reload() {
    // DatabaseReference _testRef =
    //     FirebaseDatabase.instance.reference().child("test");
    // _testRef.set("Hello world ${Random().nextInt(100)}");
    // setState(() {
    //   //sync values with cloud
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
        title: Text('Hello $_name!'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //capacity
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Capacity',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  Text(
                    '$_capacity' + 'L',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              //oxygen
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Dissolved Oxygen',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  Text(
                    '$_oxygen' + '%',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              //turbidity
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Turbidity',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  Text(
                    '$_turbidity' + ' NTU',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              //time remaining before blackwater
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Time remaining',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  Text(
                    //some calculation to split decimal hours into XhYm
                    '$_time' + ' Hours',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reload,
        tooltip: 'Reload',
        child: Icon(Icons.sync),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
