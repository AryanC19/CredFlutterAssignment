// lib/widgets/slider_widget.dart
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SliderWidget extends StatefulWidget {
  final double initialValue;
  final double min;
  final double max;
  final ValueChanged<double> onValueChanged;

  const SliderWidget({
    Key? key,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double selectedAmount;
  final Color progressBarColor = const Color(0xFFd18d71);

  @override
  void initState() {
    super.initState();
    selectedAmount = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant SliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      selectedAmount = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: widget.min,
      max: widget.max,
      initialValue: selectedAmount,
      appearance: CircularSliderAppearance(
        startAngle: 270,
        angleRange: 360,
        size: 220,
        customWidths: CustomSliderWidths(
          trackWidth: 15,
          progressBarWidth: 15,
          handlerSize: 15,
        ),
        customColors: CustomSliderColors(
          progressBarColor: progressBarColor,
          trackColor: const Color(0xFFfde9e0),
          dotColor: Colors.black,
          hideShadow: true,
          // Add this line to remove shadow
          dynamicGradient: true,
        ),
      ),
      onChange: (value) {
        setState(() {
          selectedAmount = value;
        });
        widget.onValueChanged(value);
      },
      innerWidget: (value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'credit amount',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${value.round()}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                '@1.04% monthly',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
