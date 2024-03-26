import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;
  // This is a example for a syncronous method.
  // Here within the method we don't rely on anthing from the outside world / anything that is blocking our execution
  // ex - We don't expect a huge cpu overload, We don't expect for network calls, We don't expect a I/O bpund operation to happen
  // Simply these tasks won't take that much time becuase of outside reasons so they are called as synchronous tasks.
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // We need to create a method channel instance in the flutter side.
  // We need to have a unique identifier for a method channel
  // So we have a id like 'com.januda.flutter/battery'
  // We can communicate between flutter and the specifi OS using this.
  // Either we can send information from flutter to OS or OS to flutter 
  // Here we are expecting some data to get returned from the OS
  // Note that we can call multiple methods from a single channel.
  static const platform = MethodChannel('com.januda.flutter/battery');

  // We need to get he value for the battery level
  // Instatiting a varibale for it and give a default value
  // We will call the method channel and call the platform and get the battery level and assign it
  String _batteryLevel = "Unknown Battery Level";

  // Any task that will time to execute because of a outside reason is called as asyncronous tasks.
  // ex - We expect a huge cpu overload, We expect for network calls, We expect a I/O bpund operation to happen
  // We can't gurantee how much time it will take to execute this method
  // async -> Says this task gonna take little bit longer, so don't wait for the return value.
  // Futute -> Instead of waiting , somewhere in the future the value will be returned/recieved.
  // Method will be executed in the background.
  Future<String> _getBatteryLevel() async {

    String batteryLevel;
    // **** Method channel call goes here **** 
    // We use try catch for error handling
    try {
      // We are invoking a method and give that a name. 
      // We can give it a any name.
      // But the method name that should be in the underlying OS flies should be same as this.
      // We need to undeline this method in the underlying OS.
      // <int> -> Assuring the return type of the methos as int
      // await -> Because this is a asyncronous method and we don't know how much time it will take.
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level is at $result %';
      // There might be many errors. So we are gonna catch those PlatformExceptions
    } on PlatformException {
      // We are showing the error message on top of the flutter engine.
      batteryLevel = 'Failed to get battery level';
    }

    // We need setState() method inorder the update the ui when the state changes
    // state change -> When we get the battery value from the platform
    setState(() {
      // Updates the value of the _battery Level according the value we got from the platform
      _batteryLevel = batteryLevel;
    });

    // todo: added to resolve the error
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Showing the battery level in the UI
            Text(
              _batteryLevel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Make the button call getBatteryLevel() Function
        onPressed: _getBatteryLevel,
        tooltip: 'Battery Level',
        child: const Icon(Icons.battery_unknown),
      ),
    );
  }

}