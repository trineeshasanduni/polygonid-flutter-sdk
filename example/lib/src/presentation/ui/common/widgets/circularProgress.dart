import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color? Loadingcolor;
  final Color? color;
  const Loading ({super.key, required this.Loadingcolor,required this.color});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: Loadingcolor,
        color: color,
      ),
    );
  }

 
}