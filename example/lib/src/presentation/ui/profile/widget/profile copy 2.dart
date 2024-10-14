import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:google_fonts/google_fonts.dart';

class MyProfile extends StatefulWidget {
  final String? did;
  const MyProfile({super.key, required this.did});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    // Safely decode the DID and prepare it for display
    String didValue = jsonDecode(widget.did!);

    // Show 30 characters from the start and 4 from the end
    String displayDid = didValue.length > 34
        ? didValue.substring(0, 30) + '...' + didValue.substring(didValue.length - 4)
        : didValue;

    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/jet.png'), // Replace with actual image
                ),
              ),
              // User Name
              const Text(
                'New User', // Replace with dynamic user name if necessary
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // DID Display with Copy Icon
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
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                        ),
                        overflow: TextOverflow.visible, // Handle overflow
                      ),
                    ),
                    SizedBox(width: 8),
                    // Copy IconButton
                    IconButton(
                      icon: Icon(Icons.copy, color: Colors.teal),
                      onPressed: () {
                        // Copy the full DID to clipboard
                        Clipboard.setData(ClipboardData(text: didValue));
                        // Show snackbar for feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('DID copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Profile Options
              ProfileOption(
                icon: Icons.edit,
                title: 'Edit Profile',
                onTap: () {
                  // Handle Edit Profile
                },
              ),
              ProfileOption(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  // Handle Settings
                },
              ),
              ProfileOption(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  // Handle Logout
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget for profile options
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
        leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
        onTap: onTap,
      ),
    );
  }
}
