import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/bethel_home/widget/mydata_card.dart';
class MyData extends StatefulWidget {
  const MyData({super.key});

  @override
  State<MyData> createState() => _MyDataState();
}

class _MyDataState extends State<MyData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Data"),
      ),
      body:
            MyDataCard(
              title: "Connect with a service",
              

              subtitle: "Connect witha service to add credentials about your identity",
            ),
            
          
      
    );
  }
}
