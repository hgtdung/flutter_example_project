import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let batteryChannel = FlutterMethodChannel(name: "BATTERY_CHANNEL", binaryMessenger: controller.binaryMessenger)
      
      // MARK: get battery level by StandardMessageCodec and JSONMessageCodec
      batteryChannel.setMethodCallHandler({
           [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          
          guard call.method == "getBatteryLevel" else {
             result(FlutterMethodNotImplemented)
             return
           }
           self?.receiveBatteryLevel(result: result)
         })
      
      let batteryChannelJson = FlutterMethodChannel(
        name: "BATTERY_CHANNEL_JSON",
        binaryMessenger: controller.binaryMessenger,
        codec: FlutterJSONMethodCodec.sharedInstance()
      )
      
      batteryChannelJson.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          
          guard call.method == "getBatteryLevel" else {
             result(FlutterMethodNotImplemented)
             return
           }
           self?.receiveBatteryLevelJSON(result: result)
      })
      
      // MARK: get device info by Basic message channel
      // StringCodect
      let stringChannel = FlutterBasicMessageChannel(
        name: "StringCodec",
        binaryMessenger: controller.binaryMessenger,
        codec: FlutterStringCodec.sharedInstance()
      )
      stringChannel.setMessageHandler {(message,reply) in
          if let receiveMessage = message as? String {
              reply("Model XXX")
          } else {
              reply("Invalid message format")
          }
      }
      // JsonCodec
      let jsonChannel = FlutterBasicMessageChannel(
        name: "JSONMessageCodec",
        binaryMessenger: controller.binaryMessenger,
        codec: FlutterJSONMessageCodec.sharedInstance()
      )
      jsonChannel.setMessageHandler {(message,reply) in
          if let receiveMessage = message as? [String: Any] {
              reply(["model": "Model JSONXXX"])
          } else {
              reply(["error": "Invalid message format."])
          }
      }
      
      // standardMessageCodec
      let standardChanel = FlutterBasicMessageChannel(
        name: "StandardMessageCodec",
        binaryMessenger: controller.binaryMessenger,
        codec: FlutterStandardMessageCodec.sharedInstance()
      )
      standardChanel.setMessageHandler {(message,reply) in
          if let receiveList = message as? [Int] {
              reply("Model XXXSTr: \(receiveList.count)")
          } else {
              reply(["error": "Invalid message format."])
          }
      }
      
      // binary
      let binaryChannel = FlutterBasicMessageChannel(
        name: "BinaryCodec",
        binaryMessenger: controller.binaryMessenger,
        codec: FlutterBinaryCodec.sharedInstance()
      )
      binaryChannel.setMessageHandler {(message,reply) in
          if let binaryData = message as? Any {
              let response = Data("Model XXX".utf8)
              reply(response)
          } else {
              reply(nil)
          }
      }
      
      // MARK: Event chanel - stream
      let eventChannel = FlutterEventChannel(name: "stream", binaryMessenger: controller.binaryMessenger)

      // Set up event stream handler
      eventChannel.setStreamHandler(MyEventStreamHandler())

      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled =  true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE",
                                   message: "Battery level not available.",
                                   details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
    
    private func receiveBatteryLevelJSON(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled =  true
        let response: [String: Any] = ["batteryLevel": 50]
        result(response)
    }
    
    // Stream handler to send events to Flutter
    class MyEventStreamHandler: NSObject, FlutterStreamHandler {
        var eventSink: FlutterEventSink?

        // Start the event stream (this could be a timer, sensor data stream, etc.)
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            self.eventSink = events

            // Simulate sending events every second
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.eventSink?("Event at \(Date())")
            }

            return nil
        }

        // Stop the event stream (optional, if you want to stop sending events)
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            self.eventSink = nil
            return nil
        }
    }
}

