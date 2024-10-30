import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/bloc/profile_bloc.dart';

class PersonalInfo extends StatefulWidget {
  final String? did;

  const PersonalInfo({super.key, required this.did});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  late final ProfileBloc _profileBloc;
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String addressLine1 = '';
  String addressLine2 = '';
  String city = '';
  String country = '';
  String postalCode = '';
  String states = '';

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
    _initProfile();
  }

  void _initProfile() {
    final storage = GetStorage();
    final walletAddress1 = storage.read('walletAddress');
    _profileBloc.add(GetVerifyEmailEvent(Did: jsonDecode(widget.did!)));
    _profileBloc.add(GetUpdateProfileEvent(
        Did: jsonDecode(widget.did!), OwnerAddress: walletAddress1));
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).primaryColor, // Add a background color

        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        // title: const Text('Personal Information'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          builder: (context, state) {
            // Check if the state is updated
            if (state is DataUpdated) {
              // Update the local state variables using setState
              // setState(() {
              firstName = state.profile.firstName ?? '';
              lastName = state.profile.lastName ?? '';

              phoneNumber = state.profile.phoneNumber ?? '';
              addressLine1 = state.profile.addressLine1 ?? '';
              addressLine2 = state.profile.addressLine2 ?? '';
              city = state.profile.city ?? '';
              country = state.profile.country ?? '';
              postalCode = state.profile.postalCode ?? '';
              states = state.profile.state ?? '';
              // });
            }
            if (state is EmailUpdated) {
              email = state.email.userEmail ?? '';
            }

            return SingleChildScrollView(
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
                          // backgroundImage:  // Replace with actual image
                        ),
                      ),

                      // Positioned widget to place the edit button
                      // Positioned(
                      //   bottom: 0,
                      //   right: 4,
                      //   child: InkWell(
                      //     onTap: () {
                      //       _initProfile();
                      //       // Implement the edit functionality here
                      //       print("Edit avatar clicked");
                      //     },
                      //     child: Container(
                      //       height: 40,
                      //       width: 40,
                      //       decoration: BoxDecoration(
                      //         color: Theme.of(context).colorScheme.secondary,
                      //         shape: BoxShape.circle,
                      //       ),
                      //       child: Icon(
                      //         Icons.edit,
                      //         color: Theme.of(context).primaryColor,
                      //         size: 20,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow('First Name', firstName),
                  _buildInfoRow('Last Name', lastName),
                  _buildInfoRow('Email', email),
                  _buildInfoRow('Phone Number', phoneNumber),
                  _buildInfoRow('Address Line 1', addressLine1),
                  _buildInfoRow('Address Line 2', addressLine2),
                  _buildInfoRow('City', city),
                  _buildInfoRow('Country', country),
                  _buildInfoRow('Postal Code', postalCode),
                  _buildInfoRow('State', states),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
