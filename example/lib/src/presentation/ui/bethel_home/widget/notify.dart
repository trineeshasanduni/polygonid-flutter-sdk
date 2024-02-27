import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/bethel_home/widget/notify_msg.dart';

class Notify extends StatefulWidget {
  const Notify({super.key});

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
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
          NotifyMsg(
            title: "Notofication",
            icon: Icons.language,
            bgColor: Colors.orange.shade100,
            iconColor: Colors.purple,
            value: "",
            onTap: () {},
          ),
          const SizedBox(height: 20),
          NotifyMsg(
            title: "Notofication",
            icon: Icons.language,
            bgColor: Colors.orange.shade100,
            iconColor: Colors.purple,
            value: "",
            onTap: () {},
          ),
          const SizedBox(height: 20),
          NotifyMsg(
            title: "Notofication",
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
