import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingSwitch extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final bool value;
  final Function(bool value) onTap;
  const SettingSwitch({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value ? "" : "",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          CupertinoSwitch(value: value, onChanged: onTap , activeColor: Colors.purple,),
        ],
      ),
    );
  }
}