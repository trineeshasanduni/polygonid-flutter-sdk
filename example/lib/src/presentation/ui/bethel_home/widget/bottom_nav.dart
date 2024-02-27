import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/home.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/qrcode_scanner/widgets/qrcode_scanner.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/bethel_home/widget/notify.dart';

class MyBottom extends StatefulWidget {
  const MyBottom({super.key});

  @override
  State<MyBottom> createState() => _MyBottomState();
}

class _MyBottomState extends State<MyBottom> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  

 if (selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const QRCodeScannerPage()),
      );
    } else if (selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Notify()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //  backgroundColor: Colors.purple.shade100,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.purple,
          onTap: onItemTapped,
          unselectedItemColor: Colors.black45,
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: '',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
        ],
      
    );
  }
}
