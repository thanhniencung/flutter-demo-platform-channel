import 'package:flutter/material.dart';
import 'package:flutter_demo_platform_channel/channel/basic_message.dart';
import 'package:flutter_demo_platform_channel/channel/event_channel.dart';
import 'package:flutter_demo_platform_channel/channel/method_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DemoEventChannel(),
    );
  }
}
