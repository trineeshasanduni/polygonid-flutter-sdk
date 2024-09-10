import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPlans extends StatefulWidget {
  const AddPlans({super.key});

  @override
  State<AddPlans> createState() => _AddPlansState();
}

class _AddPlansState extends State<AddPlans> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Plans")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedContainer(isExpanded1, "Basic Plan", () {
                setState(() {
                  isExpanded1 = !isExpanded1;
                });
              },
                  'Features for creators and developers who need more storage ',
                  [
                    'Unlimited Uploads',
                    '5GB storage',
                    '100GB Bandwidth',
                    'IPFS Gateways',
                    'IPFS Pinning Service API'
                  ],
                  'ADD 0\$ PER MONTH'),
              SizedBox(height: 20),
              _buildAnimatedContainer(isExpanded2, "Starter Plan", () {
                setState(() {
                  isExpanded2 = !isExpanded2;
                });
              },
                  'Perfect for those managing large files or extensive data, ensuring your information is safely stored across multiple locations',
                  [
                    'Unlimited Uploads',
                    'Upto 1000GB storage space',
                    'Hack-Proof',
                    'Blockchain-Based Secure',
                    'Decentralized Data Protection'
                  ],
                  'ADD 10\$ PER MONTH'),
              SizedBox(height: 20),
              _buildAnimatedContainer(isExpanded3, "Advance Plan", () {
                setState(() {
                  isExpanded3 = !isExpanded3;
                });
              },
                  'This plan is perfect for those needing large-scale, high-security storage solutions, ensuring that all your data is protected',
                  [
                    'Unlimited Uploads',
                    'Upto 5000GB storage space',
                    'Hack-Proof',
                    'Blockchain-Based Secure',
                    'Decentralized Data Protection'
                  ],
                  'ADD 30\$ PER MONTH'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build an expandable AnimatedContainer
  Widget _buildAnimatedContainer(
      bool isExpanded,
      String title,
      VoidCallback onTap,
      String description,
      List<String> features,
      String name1) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600), // Animation duration
        curve: Curves.easeInOut, // Animation curve
        width: MediaQuery.of(context).size.width *
            0.9, // Adjusting the width dynamically
        height: isExpanded
            ? MediaQuery.of(context).size.width // Expanded height
            : MediaQuery.of(context).size.width * 0.3, // Collapsed height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.15), // Gradient start
              Theme.of(context)
                  .colorScheme
                  .secondary
                  .withOpacity(0.5), // Gradient end
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title, // Display title text
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.robotoMono().fontFamily),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 2, // Horizontal line under the text
                ),
                if (isExpanded) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: GoogleFonts.robotoMono().fontFamily),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        'WHAT\'S INCLUDED',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.robotoMono().fontFamily),
                      ),
                      const SizedBox(height: 10),
                      // Constrain ListView height to avoid overflow
                      // _buildDashboardButton (),

                      SizedBox(
                        height: MediaQuery.of(context).size.width *
                            0.3, // Fixed height for the ListView
                        child: ListView.builder(
                          itemCount: features.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Icon(Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 12),
                                SizedBox(width: 5),
                                Text(
                                  features[index],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily:
                                          GoogleFonts.robotoMono().fontFamily),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildDashboardButton(name1),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(String name) {
    return GestureDetector(
      onTap: () {},
      child: _buildButton(name, Theme.of(context).colorScheme.secondary,
          Theme.of(context).primaryColor, Theme.of(context).primaryColor),
    );
  }

  Widget _buildButton(
      String text, dynamic colorScheme, dynamic border, dynamic textColor) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: colorScheme,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: border,
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
