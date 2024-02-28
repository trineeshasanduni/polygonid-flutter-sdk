import 'package:flutter/material.dart';

class MyDataCard extends StatelessWidget {
  final String title;
  final String subtitle;
  // final Color bgColor;
  // final Color iconColor;
  // final IconData icon;
  // final Function() onTap;
  // final String? value;
  const MyDataCard({
    super.key,
    required this.title,
    required this.subtitle,
    // required this.bgColor,
    // required this.iconColor,
    // required this.icon,
    // required this.onTap,
    // this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        // onTap: () {
        //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        //     return MyDataCard();          }));
        // },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextButton(
                        child: Text(
                          title,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        onPressed: null),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextButton(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                        onPressed: null),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                          //   return MyDataCard();
                          // }));
                        
                        },
                        child: Text(
                          'Connect',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        )),
                  ),
                  const SizedBox(
                    height: 80,
                    width: 60,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
