import 'package:flutter/material.dart';
import 'slider_widget.dart';

class ExpandedSliderCard extends StatelessWidget {
  final double initialAmount;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback onProceed;

  const ExpandedSliderCard({
    Key? key,
    required this.initialAmount,
    required this.onAmountChanged,
    required this.onProceed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Provide a unique key for AnimatedSwitcher
      key: key,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icons or close/help if you want
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  // handle close
                },
              ),
              IconButton(
                icon: Icon(Icons.help_outline, color: Colors.white),
                onPressed: () {
                  // handle help
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            "nikunj, how much do you need?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            "move the dial and set any amount you need upto ₹487,891",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),

          // White Card for the slider
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // The custom slider widget
                SliderWidget(
                  initialValue: initialAmount,
                  onValueChanged: onAmountChanged,
                ),
                const SizedBox(height: 16),
                // Footer text
                Text(
                  "stash is instant. money will be credited within seconds.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text(
                "Proceed to EMI selection",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
