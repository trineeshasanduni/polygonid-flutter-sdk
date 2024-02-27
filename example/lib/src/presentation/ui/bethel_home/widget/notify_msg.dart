import 'package:flutter/material.dart';

class NotifyMsg extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;
  final String? value;
  const NotifyMsg({
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
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        // color: Colors.white30,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    )
                    // color: bgColor,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                  ),
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
      ),
    );
  }
}
