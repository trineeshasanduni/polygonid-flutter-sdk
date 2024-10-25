import 'dart:async'; // Import the Timer package
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/register.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DashboardLoading extends StatefulWidget {
  const DashboardLoading({super.key});

  @override
  State<DashboardLoading> createState() => _DashboardLoadingState();
}

class _DashboardLoadingState extends State<DashboardLoading> {
  @override
  void initState() {
    super.initState();
    // Set a timer to navigate after 5 seconds
    Timer(const Duration(seconds: 10), () {
      // Replace with your desired page route
     Navigator.popAndPushNamed(context, '/dashboard');
         
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
