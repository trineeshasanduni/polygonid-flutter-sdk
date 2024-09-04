import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            // title: const Text('Me'),
            ),
        body: Column(
          children: [
            Container(
              child: Text(
                '102 KB used of 5GB (0%)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.robotoMono().fontFamily),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            new LinearPercentIndicator(
              // width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 3.0,
              padding: EdgeInsets.symmetric(horizontal: 20),
              animationDuration: 2000,
              percent: 0.9,
              // center: Text("90.0%"),
              // ignore: deprecated_member_use
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.greenAccent,
            ),
            SizedBox(
              height: 20,
            ),
            _buildSubmitButton(),
            SizedBox(
              height: 20,
            ),
            Expanded(child: _scrollerDetails()),
          ],
        ));
  }

  Widget _buildSubmitButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 10),
      // margin: const EdgeInsets.only(top: 80),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          'Get More Storage',
          style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.robotoMono().fontFamily),
        ),
      ),
    );
  }

   Widget _scrollerDetails() {
    final List<Map<String, dynamic>> items = [
      {'title': 'Files available offline', 'icon': Icons.event_available,'path':() },
      {'title': 'recycle bin', 'icon': Icons.delete,'path':() },
      {'title': 'Notification', 'icon': Icons.notifications,'path':() },
      {'title': 'Setting', 'icon': Icons.settings,'path': ''},
      {'title': 'Help and feedback', 'icon': Icons.help,'path': ()},
      {'title': 'Sign out', 'icon': Icons.logout,'path':SetupPasswordScreen() },
      
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(items[index]['icon'] as IconData,
                color: Theme.of(context).colorScheme.secondary),
          ),
          title: Text('${items.elementAt(index)['title']}',
              style: TextStyle(
                fontFamily: GoogleFonts.robotoMono().fontFamily,
              )),
          onTap: () {
            Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => items.elementAt(index)['path']));
          },
        );
      },
    );
  }
}
