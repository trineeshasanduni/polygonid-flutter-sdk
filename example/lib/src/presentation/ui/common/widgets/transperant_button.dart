import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';

class TransperantButton extends StatelessWidget {
  final String text;
  final double width;
  
  const TransperantButton({super.key, required this.text, required this.width});

  @override
  Widget build(BuildContext context,) {
    return FrostedGlassBox(
      theWidth: width,
      theHeight: 50.0,
      theX: 4.0,
      theY: 4.0,
      theColor: Colors.white.withOpacity(0.13),
      theChild: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary
          ], // Customize your gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white, // This will be overridden by the gradient
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.robotoMono().fontFamily,
          ),
        ),
      ),
    );
  }
  
  
}