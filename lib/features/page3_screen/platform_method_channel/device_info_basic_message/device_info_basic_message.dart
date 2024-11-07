import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceInfoBasicMessage extends StatefulWidget {
  const DeviceInfoBasicMessage({super.key});

  @override
  State<DeviceInfoBasicMessage> createState() => _DeviceInfoBasicMessageState();
}

class _DeviceInfoBasicMessageState extends State<DeviceInfoBasicMessage> {
  static const _StringCodecChannel = "StringCodec";
  static const _JSONMessageCodecChannel = "JSONMessageCodec";
  static const _BinaryCodecChannel = "BinaryCodec";
  static const _StandardMessageCodecChannel = "StandardMessageCodec";

  static const BasicMessageChannel<String> stringPlatform =
      BasicMessageChannel<String>(_StringCodecChannel, StringCodec());

  static const BasicMessageChannel<dynamic> jsonPlatform =
  BasicMessageChannel<dynamic>(_JSONMessageCodecChannel, JSONMessageCodec());

  static const BasicMessageChannel<dynamic> standardPlatform =
  BasicMessageChannel<dynamic>(_StandardMessageCodecChannel, StandardMessageCodec());

  static const BasicMessageChannel<dynamic> binaryPlatform =
    BasicMessageChannel<dynamic>(_BinaryCodecChannel, BinaryCodec());

  String _deviceInfoFromStr = "Unknown device info";
  String _deviceInfoFromJson = "Unknown device info";
  String _deviceInfoFromStandardMessage = "Unknown device info";
  String _deviceInfoFromBinary = "Unknown device info";

  @override
  void initState() {
    getDeviceInfoStringCodec();
    getDeviceInfoJsonMessageCodec();
    getDeviceInfoStandardMessageCodec();
    getDeviceInfoBinaryCodec();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  getDeviceInfoStringCodec();
                  getDeviceInfoJsonMessageCodec();
                  getDeviceInfoStandardMessageCodec();
                  getDeviceInfoBinaryCodec();
                },
                child: const Text('Get Battery Level'),
              ),
              Text(_deviceInfoFromStr, textAlign: TextAlign.center,),
              Text(_deviceInfoFromJson, textAlign: TextAlign.center,),
              Text(_deviceInfoFromStandardMessage, textAlign: TextAlign.center,),
              Text(_deviceInfoFromBinary, textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }

  void getDeviceInfoStringCodec() async {
    var str = await stringPlatform.send("GetDeviceInfo");
    setState(() {
      _deviceInfoFromStr = "Device info StringCodec"
          "\n $str";
    });
  }

  void getDeviceInfoJsonMessageCodec() async{
    var json = await jsonPlatform.send({"key": "value"});
    _deviceInfoFromJson = "Device info JSOMessageCodec"
        "\n ${json["model"]}";
  }

  void getDeviceInfoStandardMessageCodec() async{
    var str = await standardPlatform.send([1, 2 ,3 ,4]);
    setState(() {
      _deviceInfoFromStandardMessage = "Device info "
          "\n StandardMessageCodec"
          "\n${str}";
    });
  }

  void getDeviceInfoBinaryCodec() async {
    final WriteBuffer buffer = WriteBuffer()..putFloat64(1.123);
    final ByteData message = buffer.done();

    try {
      ByteData result = await binaryPlatform.send(message);
      setState(() {
        _deviceInfoFromBinary = "Device Info binary: ${message.getFloat64(0)} - ${byteDataToString(result)}";
      });
    } catch (err){
      print(err);
    }
  }

  String byteDataToString(ByteData byteData) {
    // Convert ByteData to Uint8List
    final Uint8List byteList = byteData.buffer.asUint8List();
    // Convert Uint8List to String using UTF-8 decoding
    return String.fromCharCodes(byteList);
  }
}
