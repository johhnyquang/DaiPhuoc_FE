import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget 
{
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
      super.key, 
      required this.label,
      this.onPressed,
      this.isLoading = false,
      this.icon,
      this.backgroundColor,
      this.textColor
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: isLoading ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ) : 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(icon != null) ...[
              Icon(icon),
              const SizedBox(width: 8)
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}