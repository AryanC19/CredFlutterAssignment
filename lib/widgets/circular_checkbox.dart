import 'package:flutter/material.dart';

class CircularCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const CircularCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isChecked);
      },
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          color: Colors.transparent,
        ),
        child: isChecked
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 22,
              )
            : null,
      ),
    );
  }
}
