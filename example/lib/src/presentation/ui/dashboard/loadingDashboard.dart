import 'dart:async'; // Import the Timer package
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/register.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // Set a timer to navigate after 5 seconds
    Timer(const Duration(seconds: 5), () {
      // Replace with your desired page route
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SetupPasswordScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  LoadingAnimationWidget.inkDrop(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          ,
                      size: 50,
                      ),
                ]),
          
         
      
      ),
    );
  }
}
