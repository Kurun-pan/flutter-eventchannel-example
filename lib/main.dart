import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter EventChannel API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter EventChannel API Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const EventChannel _channel = const EventChannel('com.example.eventchannel/interop');

  StreamSubscription _streamSubscription;
  String _platformMessage;

  void _enableEventReceiver() {
    _streamSubscription = _channel.receiveBroadcastStream().listen(
        (dynamic event) {
          print('Received event: $event');
          setState(() {
            _platformMessage = event;
          });
        },
        onError: (dynamic error) {
          print('Received error: ${error.message}');
        },
        cancelOnError: true);
  }

  void _disableEventReceiver() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
  }

  @override
  initState() {
    super.initState();

    _enableEventReceiver();
  }

  @override
  void dispose() {
    super.dispose();
    _disableEventReceiver();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Platform: $_platformMessage',
            ),
          ],
        ),
      ),
    );
  }
}
