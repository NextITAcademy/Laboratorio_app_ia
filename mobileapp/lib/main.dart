import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/api_client.dart';
import 'package:mobileapp/camera_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData appTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF5E35B1),
        brightness: Brightness.light,
        primary: Color(0xFF5E35B1),
        secondary: Color(0xFFD81B60),
      ),
      fontFamily: 'Montserrat',
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'oseoia',
      theme: appTheme,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _answer = "";
  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text(
              "AEDIA HEALTH",
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Toma una foto a la radiografía:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => _takePicture(context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFF5E35B1),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: imagePath.isEmpty
                    ? Image.asset(
                  "assets/camera.png",
                  width: 200,
                )
                    : Image.file(
                  File(imagePath),
                  width: 200,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _calculateMacronutrients,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD81B60),
                foregroundColor: Colors.white,
              ),
              child: const Text("¿Que observas?"),
            ),
            const SizedBox(
              height: 10,
            ),
            if (_answer.isNotEmpty) _resultsWidget(context)
          ],
        ),
      ),
    );
  }

  Widget _resultsWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF5E35B1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Información:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(_answer),
        ],
      ),
    );
  }

  _takePicture(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    if (context.mounted) {
      final imagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: firstCamera),
        ),
      );
      setState(() {
        this.imagePath = imagePath;
      });
    }
  }

  _calculateMacronutrients() {
    ApiClient().analyzeRx(imagePath).then((value) {
      setState(() {
        _answer = value.result;
      });
    }).catchError((error) {
      setState(() {
        _answer = "Error no esperado";
      });
    });
  }
}
