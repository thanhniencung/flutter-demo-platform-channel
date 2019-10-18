import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoBasicMessage extends StatefulWidget {
  @override
  _DemoBasicMessageState createState() => _DemoBasicMessageState();
}

class _DemoBasicMessageState extends State<DemoBasicMessage> {
  static const _StringCodecChannel = 'StringCodec';
  static const _JSONMessageCodecChannel = 'JSONMessageCodec';
  static const _BinaryCodecChannel = 'BinaryCodec';
  static const _StandardMessageCodecChannel = 'StandardMessageCodec';

  static const BasicMessageChannel<String> stringPlatform =
      BasicMessageChannel<String>(_StringCodecChannel, StringCodec());

  static const BasicMessageChannel<dynamic> jsonPlatform =
      BasicMessageChannel<dynamic>(
          _JSONMessageCodecChannel, JSONMessageCodec());

  static const BasicMessageChannel<dynamic> standardPlatform =
      BasicMessageChannel<dynamic>(
          _StandardMessageCodecChannel, StandardMessageCodec());

  static const BasicMessageChannel<ByteData> binaryPlatform =
      BasicMessageChannel<ByteData>(_BinaryCodecChannel, BinaryCodec());

  String _message1 = 'empty';
  String _message2 = 'empty';
  String _message3 = 'empty';
  String _message4 = 'empty';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    stringPlatform.setMessageHandler(_handleStringPlatformBack);
    jsonPlatform.setMessageHandler(_handleJsonPlatformBack);
  }

  Future<String> _handleStringPlatformBack(String response) async {
    setState(() {
      _message1 = response;
    });
    return "";
  }

  Future<dynamic> _handleJsonPlatformBack(dynamic response) async {
    setState(() {
      _message2 = response['phone'];
    });
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo BasicMessage'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_message1),
              RaisedButton(
                onPressed: () {
                  callNativeStringCodec();
                },
                child: Text('StringCodec'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(_message2),
              RaisedButton(
                onPressed: () {
                  callNativeJSONMessageCodec();
                },
                child: Text('JSONMessageCodec'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(_message3),
              RaisedButton(
                onPressed: () {
                  callNativeBinaryCodec();
                },
                child: Text('BinaryCodec'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(_message4),
              RaisedButton(
                onPressed: () {
                  callNativeStandardMessageCodec();
                },
                child: Text('StandardMessageCodec'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void callNativeStringCodec() {
    print('callNativeStringCodec');
    stringPlatform.send("Ryan");
  }

  void callNativeJSONMessageCodec() {
    print('callNativeJSONMessageCodec');
    jsonPlatform.send("");
  }

  void callNativeBinaryCodec() async {
    final WriteBuffer buffer = WriteBuffer()..putFloat64(1.123);
    final ByteData message = buffer.done();

    ByteData result = await binaryPlatform.send(message);
    setState(() {
      _message3 = 'Received ${result.getFloat64(0)}';
    });
  }

  void callNativeStandardMessageCodec() async {
    var list = await standardPlatform.send([1, 2, 3, 4]);
    setState(() {
      _message4 = list.toString();
    });
  }
}
