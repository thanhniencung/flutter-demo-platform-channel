import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoEventChannel extends StatefulWidget {
  @override
  _DemoEventChannelState createState() => _DemoEventChannelState();
}

class _DemoEventChannelState extends State<DemoEventChannel> {
  static const stream = const EventChannel('stream');
  String _message = 'empty';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    stream.receiveBroadcastStream().listen((data) {
      setState(() {
        _message = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Event Channel'),
      ),
      body: Center(
        child: Container(
          child: Text(
            _message,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
