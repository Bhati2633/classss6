import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AgeCounter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Age Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// AgeCounter model with milestone messages and background color.
class AgeCounter with ChangeNotifier {
  int age = 0;

  void increment() {
    age += 1;
    notifyListeners();
  }

  void decrement() {
    if (age > 0) {
      age -= 1;
      notifyListeners();
    }
  }

  String get milestoneMessage {
    if (age >= 0 && age <= 12) {
      return "You're a child!";
    } else if (age >= 13 && age <= 19) {
      return "Teenager time!";
    } else if (age >= 20 && age <= 30) {
      return "You're a young adult!";
    } else if (age >= 31 && age <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden years!";
    }
  }

  Color get backgroundColor {
    if (age >= 0 && age <= 12) {
      return Colors.lightBlue;
    } else if (age >= 13 && age <= 19) {
      return Colors.lightGreen;
    } else if (age >= 20 && age <= 30) {
      return Colors.yellow;
    } else if (age >= 31 && age <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ageCounter = context.watch<AgeCounter>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter with Milestones'),
      ),
      body: Container(
        color: ageCounter.backgroundColor, // Set the background color based on age
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Your current age is:'),
              Text(
                '${ageCounter.age}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20), // Add some space
              Text(
                ageCounter.milestoneMessage,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              ageCounter.decrement();
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16), // Space between buttons
          FloatingActionButton(
            onPressed: () {
              ageCounter.increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
