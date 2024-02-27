import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/bethel_home/widget/setting_list.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/bethel_home/widget/setting_switch.dart';
class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isDarkMode = false;
  bool isPasscode = false;
  bool isBackUp = false;
  bool isStacktrace = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leadingWidth: 60, 
        iconTheme: const IconThemeData(
          color: Colors.grey,
          
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Reset Password",
                    icon: Icons.language,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Enable Face ID",
                    icon: Icons.face_rounded,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SettingSwitch(
                    title: "Dark Mode",
                    icon: Icons.electrical_services,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: isDarkMode,
                    onTap: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingSwitch(
                    title: "Ask Passcode to sign in",
                    icon: Icons.lock,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: isPasscode,
                    onTap: (value) {
                      setState(() {
                        isPasscode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingSwitch(
                    title: "Back up Credentials",
                    icon: Icons.electrical_services,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: isBackUp,
                    onTap: (value) {
                      setState(() {
                        isBackUp = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Back up your wallet",
                    icon: Icons.wallet,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                  const SizedBox(height: 40),
                  SettingItem(
                    title: "Remove my credentials",
                    icon: Icons.remove,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Remove my identity",
                    icon: Icons.close_rounded,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Clean Schema cache",
                    icon: Icons.cleaning_services,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SettingSwitch(
                    title: "Enable stacktrace",
                    icon: Icons.electrical_services,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: isStacktrace,
                    onTap: (value) {
                      setState(() {
                        isStacktrace = value;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  SettingItem(
                    title: "Privacy policy",
                    icon: Icons.privacy_tip_outlined,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Terms and Conditions",
                    icon: Icons.info_outline,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                  const SizedBox(height: 40),
                  SettingItem(
                    title: "Sign out",
                    icon: Icons.logout,
                    bgColor: Colors.grey.shade100,
                    iconColor: Colors.grey,
                    value: "",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
        

      ),
    );
  }
}
