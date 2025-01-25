import 'package:flutter/material.dart';

class CollapsedRow extends StatelessWidget {
  final double amount;
  final VoidCallback onTap;

  const CollapsedRow({
    Key? key,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Credit amount:",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "₹${amount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_drop_down, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }
}
