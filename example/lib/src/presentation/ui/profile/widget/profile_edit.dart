import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  var fname = TextEditingController();
  var lname = TextEditingController();
  var aLine1 = TextEditingController();
  var aLine2 = TextEditingController();
  var zipcode = TextEditingController();
  var tel = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var email = TextEditingController();
  var country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        // title: Text('Edit Profile'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).secondaryHeaderColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                // Profile Image with Edit Icon
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      // backgroundImage: AssetImage('assets/images/avatar.jpg'), // Replace with your image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          // Implement your image edit functionality here
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
          
                // Full Name Field
                buildTextField(
                  label: 'First Name',
                  icon: Icons.person,
                  hintText: 'Enter your first name',
                  controller: fname
                ),
                buildTextField(
                  label: 'Last Name',
                  icon: Icons.person,
                  hintText: 'Enter your first name',
                  controller: lname
                ),
                buildTextField(
                  label: 'E-Mail',
                  icon: Icons.email,
                  hintText: 'support@codingwitht.com',
                  keyboardType: TextInputType.emailAddress,
                  controller: email
                ),
          
                // Phone Number Field
                buildTextField(
                  label: 'Phone No',
                  icon: Icons.phone,
                  hintText: '+92 317 8059528',
                  keyboardType: TextInputType.phone,
                  controller: tel
                ),
                buildTextField(
                  label: 'Address Line 1',
                  icon: Icons.add_location,
                  hintText: 'Enter your address line 1',
                  controller: aLine1
                ),
                buildTextField(
                  label: 'Address Line 2',
                  icon: Icons.add_location,
                  hintText: 'Enter your address line 2',
                  controller: aLine2
                ),
                 buildTextField(
                  label: 'City',
                  icon: Icons.place,
                  hintText: 'Enter your city',
                  controller: city
                ),
                 buildTextField(
                  label: 'State',
                  icon: Icons.business,
                  hintText: 'Enter your state',
                  controller: state
                ),
                 buildTextField(
                  label: 'Zip code',
                  icon: Icons.code,
                  hintText: 'Enter your zip code',
                  controller: zipcode
                ),
                
                buildTextField(
                  label: 'Country',
                  icon: Icons.flag,
                  hintText: 'Enter your country',
                  controller: country
                ),
          
                
                
          
                
          
                SizedBox(height: 30),
          
                // Edit Profile Button
                _buildEdtdButton(),
          
               
          
                // Joined Date and Delete Button
                
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
            builder: (context) =>  EditProfilePage(),
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

  // Helper method to build TextFormField
  Widget buildTextField({
    required String label,
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.secondary),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary,fontFamily: GoogleFonts.robotoMono().fontFamily,fontSize: 12),
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            // borderSide: BorderSide.,
            
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(Icons.visibility_off, color: Theme.of(context).colorScheme.secondary),
                  onPressed: () {
                    // Toggle password visibility
                  },
                )
              : null,
        ),
      ),
    );
  }
}
