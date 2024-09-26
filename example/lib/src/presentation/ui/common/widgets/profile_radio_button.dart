import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';

enum SelectedProfile { public, private }

typedef ProfileCallback = void Function(SelectedProfile);

class ProfileRadio extends StatelessWidget {
  const ProfileRadio(SelectedProfile profile, ProfileCallback profileCallback,
      {Key? key})
      : _profile = profile,
        _profileCallback = profileCallback,
        super(key: key);

  final ProfileCallback _profileCallback;
  final SelectedProfile? _profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _makeRadioListTile(
            CustomStrings.authPublicProfile, SelectedProfile.public,context),
        _makeRadioListTile(
            CustomStrings.authPrivateProfile, SelectedProfile.private,context),
      ],
    );
  }

  Widget _makeRadioListTile(String text, SelectedProfile value ,BuildContext context) {
    return RadioListTile(
        title: Text(text,style: TextStyle(color: Theme.of(context).primaryColor),),
        value: value,
        groupValue: _profile,
        activeColor: Theme.of(context).colorScheme.secondary,
        onChanged: (SelectedProfile? value) {
          _profileCallback(value!);
        });
  }
}
