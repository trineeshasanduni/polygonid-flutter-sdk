import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/bloc/profile_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/widget/activityLogs.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/widget/profile_edit.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/splash/widgets/splash.dart';

class MyProfile extends StatefulWidget {
  final String? did;
  const MyProfile({super.key, required this.did});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  

 

  @override
  Widget build(BuildContext context) {
    String didValue = jsonDecode(widget.did!);

    // Show 30 characters from the start and 4 from the end
    String displayDid = didValue.length > 34
        ? didValue.substring(0, 30) +
            '...' +
            didValue.substring(didValue.length - 4)
        : didValue;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                // Profile Picture, Name, and Email Section
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  // color: Colors.blue[400],
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Circle Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              foregroundColor: Colors.white,

                              backgroundColor: Theme.of(context)
                                  .secondaryHeaderColor
                                  .withOpacity(0.1),
                              backgroundImage: AssetImage(
                                  'assets/images/jet.png'), // Replace with actual image
                            ),
                          ),

                          // Positioned widget to place the edit button
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: InkWell(
                              onTap: () {
                                // Implement the edit functionality here
                                print("Edit avatar clicked");
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'New User', // Replace with dynamic name
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Display the shortened DID in a Flexible widget to prevent overflow
                            Flexible(
                              child: Text(
                                displayDid,

                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontFamily:
                                      GoogleFonts.robotoMono().fontFamily,
                                ),
                                overflow:
                                    TextOverflow.visible, // Handle overflow
                              ),
                            ),
                            SizedBox(width: 8),
                            // Copy IconButton
                            IconButton(
                              icon: Icon(Icons.copy,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                // Copy the full DID to clipboard
                                Clipboard.setData(
                                    ClipboardData(text: didValue));
                                // Show snackbar for feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('DID copied to clipboard')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                _buildEdtdButton(),

                // Icon Button Row Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),

                // Information Rows Section
                SizedBox(height: 16),
                // Profile Options

                ProfileOption(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    // Handle Settings
                  },
                ),
                ProfileOption(
                  icon: Icons.attractions,
                  title: 'Activities',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPanel(did: widget.did)));
                  },
                ),
                Divider(
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
                ),
                ProfileOption(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    // Handle Logout
                    // Navigator.of(context).pushReplacementNamed(Routes.splashPath);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
                  },
                ),

                // Bottom Button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEdtdButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfilePage(),
          ),
        );
      },
      child: _buildButton(
          context,
          'Edit Profile',
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
          Colors.black,
          Theme.of(context).primaryColor),
    );
  }

  Widget _buildButton(BuildContext context, String text, dynamic colorScheme,
      dynamic colorScheme2, dynamic border, dynamic textColor) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme, colorScheme2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
            30.0), // Optional: Add some rounding to the button
      ),
      child: FrostedGlassBox(
        theWidth: MediaQuery.of(context).size.width,
        theHeight: 50.0,
        theX: 0.0,
        theY: 0.0,
        theColor: Colors.white
            .withOpacity(0.13), // This can remain for frosted glass effect
        theChild: Text(
          text,
          style: TextStyle(
            fontSize: 12.0,
            color:
                textColor, // Keep the text color simple since the gradient is on the button
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.robotoMono().fontFamily,
          ),
        ),
      ),
    );
  }

// Widget for building information rows
  Widget buildEditableInfoRow(String label, bool isPassword,
      {String initialValue = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              obscureText:
                  isPassword, // Makes the input obscure for Password field
              decoration: InputDecoration(
                suffixText: isPassword ? 'Change' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Icon Button widget for Profile actions
class ProfileIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ProfileIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: Theme.of(context).colorScheme.secondary,
          iconSize: 30,
          onPressed: onPressed,
        ),
        // SizedBox(height: 4),
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 10,
        //     // fontWeight: FontWeight.w00,
        //     color: Theme.of(context).secondaryHeaderColor,
        //     fontFamily: GoogleFonts.robotoMono().fontFamily,
        //   ),
        // ),
      ],
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.secondary)),
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        trailing: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
            ),
            child: Icon(Icons.arrow_forward_ios, color: Colors.grey[600])),
        onTap: onTap,
      ),
    );
  }
}
