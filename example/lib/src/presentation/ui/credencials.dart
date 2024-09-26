import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claims.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/claim.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/image_resource.dart';

class Credencials extends StatefulWidget {
  const Credencials({super.key});

  @override
  State<Credencials> createState() => _CredencialsState();
}

class _CredencialsState extends State<Credencials> {
  // final List<Map<String, dynamic>> categories = [
  //   {
  //     'name': 'User Authentication',
  //     'icon': Icons.verified_user,
  //     'onTap': ClaimsScreen()
  //   },
  //   {
  //     'name': 'File Credentials',
  //     'icon': Icons.file_present,
  //     'onTap': ClaimsScreen()
  //   },
  //   {'name': 'File', 'icon': Icons.school, 'onTap': ClaimsScreen()},
  //   {'name': 'File', 'icon': Icons.sports_soccer, 'onTap': ClaimsScreen()},
  //   {'name': 'File', 'icon': Icons.movie, 'onTap': ClaimsScreen()},
  //   {'name': 'File', 'icon': Icons.business, 'onTap': ClaimsScreen()},
  // ];
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'User Authentications',
      'subtitle': 'Issuer claims.',
      'image': 'assets/images/bg.png',
      'onTap': ClaimsScreen()
    },
    {
      'title': 'File Credentials',
      'subtitle': 'Issuer claims.',
      'image': 'assets/images/bg.png',
      'onTap': ClaimsScreen()
    },
    {
      'title': 'File',
      'subtitle': 'Issuer claims.',
      'image': 'assets/images/bg.png',
      'onTap': ClaimsScreen()
    },
    // {
    //   'title': 'Coffee',
    //   'subtitle': 'Enthusiastically architect.',
    //   'image': 'assets/images/coffee.jpg',
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        // appBar: AppBar(
        //   title: const Text('Clamis'),
        // ),
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item['onTap'],
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          _buildBackgroundImage(item['image']!),
                          _buildTextOverlay(item['title']!, item['subtitle']!),
                        ],
                      ),
                      
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      title: Row(
        children: [
          Image.asset('assets/images/launcher_icon.png', width: 30, height: 30),
          RichText(
            text: TextSpan(
              text: 'zkp',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
                fontWeight: FontWeight.w300,
              ),
              children: [
                TextSpan(
                  text: 'STORAGE',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20,
                    fontFamily: GoogleFonts.robotoMono().fontFamily,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 1),
        ),
        child: GestureDetector(
          onTap: () {
            // _showWelcomeDialog();
            // _refreshApp();
          },
          child: Icon(
            Icons.wallet,
            color: Theme.of(context).secondaryHeaderColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(String imagePath) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTextOverlay(String title, String subtitle) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
