import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SliderWidget extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onValueChanged;

  const SliderWidget({
    Key? key,
    required this.initialValue,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double selectedAmount;

  @override
  void initState() {
    super.initState();
    selectedAmount = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: 0,
      max: 487891,
      initialValue: selectedAmount,
      appearance: CircularSliderAppearance(
        startAngle: 270,
        angleRange: 360,
        size: 220,
        customWidths: CustomSliderWidths(
          trackWidth: 10,
          progressBarWidth: 10,
          handlerSize: 15,
        ),
        customColors: CustomSliderColors(
          progressBarColor: Colors.transparent,
          trackColor: Colors.transparent,
          dotColor: Colors.brown,
          hideShadow: true,
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
              Text(
                '@1.04% monthly',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
