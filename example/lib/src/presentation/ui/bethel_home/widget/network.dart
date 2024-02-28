import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/bethel_home/widget/network_card.dart';

class Network extends StatelessWidget {
  const Network({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade50,
        elevation: 0,
        leadingWidth: 60,
        iconTheme: const IconThemeData(
          color: Colors.purple,
        ),
      ),
      body: Container(

        child: Column(children: [
          const SizedBox(height: 20),
          NetworkCard(
            title: "Polygon Mumbai",
            icon: Icons.language,
            bgColor: Colors.orange.shade100,
            iconColor: Colors.purple,
            value: "",
            onTap: () {},
          ),
          const SizedBox(height: 20),
          NetworkCard(
            title: "polygon Mainnet",
            icon: Icons.language,
            bgColor: Colors.orange.shade100,
            iconColor: Colors.purple,
            value: "",
            onTap: () {},
          ),
          
        ]),
      ),
    );
  }
}