import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _batteryLevel = 'Unknown level';
  late Future future;

  Future<void> _getBatteryLevel() async {
    dynamic batteryLevel;
    const platform = MethodChannel('course.flutter.dev/battery');
    try {
      batteryLevel = await platform.invokeMethod('getBatteryLevel', []);
    } on PlatformException catch (e) {
      print(e);
      batteryLevel = 'error occured';
    }
    setState(() {
      _batteryLevel = batteryLevel.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    future = _getBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery checker'),
      ),
      body: Center(
        child: FutureBuilder(
            future: future,
            builder: (ctx, dataSnap) {
              if (dataSnap.connectionState != ConnectionState.waiting) {
                if (dataSnap.hasError) {
                  print(dataSnap.error);
                  return Center(child: Text('Error occured! See console.'));
                } else {
                  return Text('Battery level: $_batteryLevel');
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
