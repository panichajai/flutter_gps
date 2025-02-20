import 'package:flutter/material.dart';

Widget buildButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
  required bool isOutlined,
  bool isPrimary = false,
  bool isDanger = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  Color primaryColor = colorScheme.primary;
  Color dangerColor = colorScheme.error;
  Color textColor = isDanger ? dangerColor : primaryColor;

  if (isOutlined) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(
              color: isDanger ? dangerColor : primaryColor), // ✅ กำหนดขอบสีแดง
          minimumSize: isPrimary
              ? const Size(double.infinity, 52)
              : const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDanger ? dangerColor : primaryColor, // ✅ เปลี่ยนสีพื้นหลัง
          foregroundColor: colorScheme.onPrimary,
          minimumSize: isPrimary
              ? const Size(double.infinity, 52)
              : const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
