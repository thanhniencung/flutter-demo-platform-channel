import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoMethodChannel extends StatefulWidget {
  @override
  _MethodChannelState createState() => _MethodChannelState();
}

class _MethodChannelState extends State<DemoMethodChannel> {
  static const defaultPlatform = MethodChannel('com.code4func/method1');

  static const platform =
      MethodChannel('com.code4func/method2', JSONMethodCodec());

  String _deviceInfo1 = 'empty';
  String _deviceInfo2 = 'empty';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo MethodChannel'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_deviceInfo1),
              RaisedButton(
                onPressed: () {
                  _standardMethodCodec("model");
                },
                child: Text('StandardMethodCodec'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(_deviceInfo2),
              RaisedButton(
                onPressed: () {
                  _jSONMethodCodec("model");
                },
                child: Text('JSONMethodCodec'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _standardMethodCodec(String model) async {
    try {
      String result =
          await defaultPlatform.invokeMethod('getDeviceInfoString', {
        "type": "MODEL",
      });

      if (result != null) {
        _deviceInfo1 = result;
      } else {
        _deviceInfo1 = 'can not get device info';
      }
    } on PlatformException catch (e) {
      _deviceInfo1 = e.message;
    }

    setState(() {});
  }

  _jSONMethodCodec(String model) async {
    try {
      var result = await platform.invokeMethod('getDeviceInfo', {
        "type": "MODEL",
      });

      if (result != null) {
        _deviceInfo2 = result['result'];
      } else {
        _deviceInfo2 = 'can not get device info';
      }
    } on PlatformException catch (e) {
      _deviceInfo2 = e.message;
    }

    setState(() {});
  }
}
