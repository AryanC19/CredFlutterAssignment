// lib/models/emi_option.dart

class EMIOption {
  final String amountPerMonth;
  final String duration;
  final bool isRecommended;
  bool isSelected;

  EMIOption({
    required this.amountPerMonth,
    required this.duration,
    required this.isRecommended,
    this.isSelected = false,
  });
}
