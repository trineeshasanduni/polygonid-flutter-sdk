// import 'package:account_example/widgets/arrow_button.dart';
import 'package:flutter/material.dart';


class SettingItem extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;
  final String? value;
  const SettingItem({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: SizedBox(
        width: double.infinity,
        
        
        child: Row(
          children: [
            
            Container(
              height: 35,
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
            value != null
                ? Text(
                    value!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(width: 20),
            // ArrowButton(
            //   onTap: onTap,
            // ),
          ],
        ),
      ),
    );
  }
}
