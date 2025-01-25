import 'dart:math';
import 'package:flutter/material.dart';

num degToRad(num deg) => deg * (pi / 180.0);

double normalize(num value, num min, num max) =>
    ((value - min) / (max - min)).toDouble();

const Color kScaffoldBackgroundColor = Color(0xFFF3FBFA);
const int kDiameter = 270; // Diameter for the circle
const int kMinDegree = 0;
const int kMaxDegree = 487891; // Maximum value for the amount
