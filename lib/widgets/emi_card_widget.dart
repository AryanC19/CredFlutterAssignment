import 'package:flutter/material.dart';
import 'circular_checkbox.dart';

class EMICardWidget extends StatelessWidget {
  final String amountPerMonth;
  final String duration;
  final bool isRecommended;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const EMICardWidget({
    Key? key,
    required this.amountPerMonth,
    required this.duration,
    required this.isRecommended,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Crucial for overflow
      children: [
        GestureDetector(
          onTap: () => onSelected(!isSelected),
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF094261),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircularCheckbox(
                  isChecked: isSelected,
                  onChanged: (value) => onSelected(value),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Split the string into amount and duration
                    Text(
                      amountPerMonth
                          .split(' for ')
                          .first, // First part (₹4274/mo)
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'for ${amountPerMonth.split(' for ').last}', // Second part (for 2 months)
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  duration,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        if (isRecommended)
          Positioned(
            top: -15, // Increased negative value
            left: -10,
            right: 8,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Text(
                  'recommended',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
