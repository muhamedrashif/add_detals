import 'dart:async';
import 'package:add_detals/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate the splash screen duration
    Timer(const Duration(seconds: 3), () {
      // Navigate to the main screen after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => InitializerWidget(),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: const Column(
          children: [
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://media.istockphoto.com/id/1170109030/photo/group-of-people-holding-hands-with-one-leader-orange-man-in-center-of-the-circle-business.jpg?s=612x612&w=0&k=20&c=YfRP9sILIhUnIeJb1NkmetRHRPh9VFZWfevzK2PsGbo='),
                  radius: 60,
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Add Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
