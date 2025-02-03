// lib/widgets/expanded_amount_slider.dart
import 'package:flutter/material.dart';
import 'slider_widget.dart';

class ExpandedAmountSlider extends StatefulWidget {
  final double initialAmount;
  final double min;
  final double max;
  final ValueChanged<double> onAmountChanged;
  final String title;
  final String subtitle;
  final String footer;

  const ExpandedAmountSlider({
    Key? key,
    required this.initialAmount,
    required this.min,
    required this.max,
    required this.onAmountChanged,
    required this.title,
    required this.subtitle,
    required this.footer,
  }) : super(key: key);

  @override
  State<ExpandedAmountSlider> createState() => _ExpandedAmountSliderState();
}

class _ExpandedAmountSliderState extends State<ExpandedAmountSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialAmount;
  }

  @override
  void didUpdateWidget(covariant ExpandedAmountSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAmount != widget.initialAmount) {
      _currentValue = widget.initialAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF262A3D), // Add 0xFF for full opacity
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 6),
                      Text(widget.subtitle,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14)),

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
                              initialValue: _currentValue,
                              min: widget.min,
                              max: widget.max,
                              onValueChanged: (val) {
                                setState(() {
                                  _currentValue = val;
                                });
                                widget.onAmountChanged(val);
                              },
                            ),
                            const SizedBox(height: 16),
                            // Footer text
                            Text(
                              widget.footer,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 14),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
