import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/transperant_button.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final String? did;

  const EditProfilePage({super.key, required this.did});
  // @override
  // _EditProfilePageState createState() => _EditProfilePageState();

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
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

  late final ProfileBloc _profileBloc;
  final isEmailValid = false;
  var isTel = false;
  var isVerified = false;
  var isTelVerified = false;
  var countrycode;

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
    // email.addListener(() {
    //   setState(() {
    //     // Check if the email field is not empty
    //     isEmailValid = email.text.isNotEmpty;
    //     print('isEmailValid: $isEmailValid');
    //   });
    // });

    tel.addListener(() {
      setState(() {
        // Check if the email field is not empty
        isTel = tel.text.isNotEmpty;
        print('isEmailValid: $isTel');
      });
    });

    _profileBloc.add(GetVerifyEmailEvent(Did: jsonDecode(widget.did!)));
  }

  void _showSnackbar(String message, Color? backgroundColor) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final String Did = jsonDecode(widget.did!);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        // title: Text('Edit Profile'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).secondaryHeaderColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                    controller: fname),
                buildTextField(
                    label: 'Last Name',
                    icon: Icons.person,
                    hintText: 'Enter your first name',
                    controller: lname),
                BlocBuilder<ProfileBloc, ProfileState>(
                  bloc: _profileBloc,
                  builder: (context, state) {
                    if (state is EmailUpdated) {
                      // setState(() {
                      email.text = state.email.userEmail!;
                      isVerified = state.email.isVerified!;
                      print('verified: $isVerified');

                      print('email: ${state.email.userEmail}');
                      // });
                    }
                    return buildTextField(
                      label: 'E-Mail',
                      icon: Icons.email,
                      hintText: 'example@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                    );
                  },
                ),
                isVerified
                    ? const SizedBox(
                        height: 10,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: email.text.isNotEmpty
                                ? () async {
                                    _profileBloc.add(VerifyEmailEvent(
                                        Did: Did, UserEmail: email.text));

                                    _showEmailVerify(context, Did, email);
                                  }
                                : null, // Disable button when email is empty
                            child: Text(
                              'Verify Email',
                              style: TextStyle(
                                color: email.text.isNotEmpty
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors
                                        .grey, // Change text color when disabled
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                // Phone Number Field
                // buildTextField(
                //     label: 'Phone No',
                //     icon: Icons.phone,
                //     hintText: '',
                //     keyboardType: TextInputType.phone,
                //     controller: tel),
                IntlPhoneField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: GoogleFonts.robotoMono().fontFamily,
                      fontSize: 12,
                    ),
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone,
                        color: Theme.of(context).colorScheme.secondary),
                    filled: true,
                    fillColor: Theme.of(context).primaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  initialCountryCode: 'LK',
                  onChanged: (phone) {
                    setState(() {
                      countrycode = phone.countryCode;
                    });
                  },
                  controller: tel,
                ),
                isTelVerified
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isTel
                                ? () {
                                    String countryCodeWithoutPlus =
                                        countrycode.replaceAll("+", "");
                                    print(
                                        'telp: ${countryCodeWithoutPlus + tel.text}');
                                    _profileBloc.add(VerifyTelEvent(
                                      DID: Did,
                                      Mobile: countryCodeWithoutPlus + tel.text,
                                    ));

                                    _showTelVerify(context, Did);
                                  }
                                : null,
                            child: BlocBuilder<ProfileBloc, ProfileState>(
                              bloc: _profileBloc,
                              builder: (context, state) {
                                if (state is Sending) {
                                  return Center(
                                    child: Loading(
                                      Loadingcolor:
                                          Theme.of(context).primaryColor,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  );
                                }

                                if (state is OTPSend) {
                                  _showSnackbar(
                                      'OTP sent successfully!,\nCheck your Phone and enter OTP here',
                                      Colors.green);
                                }
                                return Text(
                                  'Verify Phone No',
                                  style: TextStyle(
                                    color: isTel
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                buildTextField(
                    label: 'Address Line 1',
                    icon: Icons.add_location,
                    hintText: 'Enter your address line 1',
                    controller: aLine1),
                buildTextField(
                    label: 'Address Line 2',
                    icon: Icons.add_location,
                    hintText: 'Enter your address line 2',
                    controller: aLine2),
                buildTextField(
                    label: 'City',
                    icon: Icons.place,
                    hintText: 'Enter your city',
                    controller: city),
                buildTextField(
                    label: 'State',
                    icon: Icons.business,
                    hintText: 'Enter your state',
                    controller: state),
                buildTextField(
                    label: 'Zip code',
                    icon: Icons.code,
                    hintText: 'Enter your zip code',
                    controller: zipcode),

                buildTextField(
                    label: 'Country',
                    icon: Icons.flag,
                    hintText: 'Enter your country',
                    controller: country),

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
        print('did: ${jsonDecode(widget.did!)}');
        _profileBloc.add(GetVerifyEmailEvent(Did: jsonDecode(widget.did!)));
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
    VoidCallback? onTextButtonPressed, // Add a callback for TextButton action
    String? buttonText, // Add optional button text
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontFamily: GoogleFonts.robotoMono().fontFamily,
          fontSize: 12,
        ),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              Icon(icon, color: Theme.of(context).colorScheme.secondary),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontFamily: GoogleFonts.robotoMono().fontFamily,
            fontSize: 12,
          ),
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Future<void> _showEmailVerify(
      BuildContext context, String did, TextEditingController email) async {
    var token = TextEditingController();

    showModalBottomSheet(
      backgroundColor:
          Colors.transparent, // Set to transparent to allow the gradient
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to take up more space
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3, // Initial height
          maxChildSize: 0.9, // Max height when dragged
          minChildSize: 0.3, // Minimum height when collapsed
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 68, 91, 0),
                    Theme.of(context).primaryColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Adjust height based on content
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.only(top: 5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: token,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Enter Verification Code',
                          labelStyle: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontFamily: GoogleFonts.robotoMono().fontFamily,
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        bloc: _profileBloc,
                        builder: (context, state) {
                          if (state is Sending) {
                            return Center(
                              child: Loading(
                                Loadingcolor: Theme.of(context).primaryColor,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          }

                          if (state is Updating) {
                            return Center(
                              child: Loading(
                                Loadingcolor: Theme.of(context).primaryColor,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            );
                          }
                          if (state is EmailSend) {
                            _showSnackbar(
                                'Email sent successfully!,\nCheck your Mail and enter verification code here',
                                Colors.green);
                          }
                          if (state is Verifying) {
                            return Center(
                              child: Loading(
                                Loadingcolor: Theme.of(context).primaryColor,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            );
                          }

                          if (state is EmailSentFailed) {
                            _showSnackbar(
                                'email Send Failed : ${state.message}',
                                Colors.red);
                          }
                          if (state is EmailVerified) {
                            _showSnackbar(
                                'Email Verified Successfully', Colors.green);
                          }
                          return Center(
                            child: GestureDetector(
                                onTap: () {
                                  _profileBloc.add(UpdateVerifyEmailEvent(
                                      Did: did,
                                      UserEmail: email.text,
                                      Token: token.text));
                                },
                                child: TransperantButton(
                                    text: 'Submit',
                                    width:
                                        MediaQuery.of(context).size.width / 4)),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showTelVerify(BuildContext context, String did) async {
    var token = TextEditingController();

    showModalBottomSheet(
      backgroundColor:
          Colors.transparent, // Set to transparent to allow the gradient
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to take up more space
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3, // Initial height
          maxChildSize: 0.9, // Max height when dragged
          minChildSize: 0.3, // Minimum height when collapsed
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 68, 91, 0),
                    Theme.of(context).primaryColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Adjust height based on content
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.only(top: 5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: token,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          labelStyle: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontFamily: GoogleFonts.robotoMono().fontFamily,
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        bloc: _profileBloc,
                        builder: (context, state) {
                          if (state is OtpVerifiying) {
                            return Center(
                              child: Loading(
                                Loadingcolor: Theme.of(context).primaryColor,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          }

                          if (state is Validate) {
                            _showSnackbar('Phone Number Verified successfully!',
                                Colors.green);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                isTelVerified = state.otp.validate!;
                                print('validate tel: $isTelVerified');
                              });
                            });
                          }

                          return Center(
                            child: GestureDetector(
                                onTap: () {
                                  _profileBloc.add(ValidateOTPEvent(
                                      Did: jsonDecode(widget.did!),
                                      OTP: token.text));
                                },
                                child: TransperantButton(
                                    text: 'Submit',
                                    width:
                                        MediaQuery.of(context).size.width / 4)),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
