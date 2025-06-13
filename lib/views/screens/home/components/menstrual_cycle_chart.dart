
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:women_health/utils/constant/app_theme.dart';

import '../../../../core/models/period_data.dart';


class MenstrualCycleChart extends StatelessWidget {
  final int cycleLength;
  final int currentDayOfCycle;
  final CyclePhase currentPhase;

  // These can be customized based on user data or app settings
  final int menstruationLength;
  final int ovulationStartDay;

  const MenstrualCycleChart({
    super.key,
    required this.cycleLength,
    required this.currentDayOfCycle,
    required this.currentPhase,
    this.menstruationLength = 5, // Default period length
    this.ovulationStartDay = 14, // A common average
  });

  // Helper to determine the text in the center based on the current phase
  Widget _buildCenterContent() {
    String title;
    String subtitle;
    String mainText;

    switch (currentPhase) {
      case CyclePhase.menstruation:
        title = "Menstruation";
        mainText = "Day $currentDayOfCycle";
        subtitle = "Energy levels may be lower";
        break;
      case CyclePhase.follicular:
        title = "Follicular Phase";
        mainText = "Day $currentDayOfCycle";
        subtitle = "Energy may be increasing";
        break;
      case CyclePhase.ovulation:
        // This logic matches the example image
        title = "Best chance to conceive is in";
        mainText = "${ovulationStartDay - currentDayOfCycle} Days";
        if (currentDayOfCycle == ovulationStartDay) {
          mainText = "Today";
        } else if (currentDayOfCycle > ovulationStartDay) {
          mainText = "High"; // Or whatever you want to show post-ovulation day
        }
        subtitle = "High chance of getting pregnant";
        break;
      case CyclePhase.luteal:
        title = "Luteal Phase";
        mainText = "Day $currentDayOfCycle";
        subtitle = "PMS symptoms might appear";
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          mainText,
          textAlign: TextAlign.center,
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The Custom Painter for the circle, numbers, and labels
          CustomPaint(
            painter: _MenstrualCyclePainter(
              cycleLength: cycleLength,
              currentDay: currentDayOfCycle,
              menstruationLength: menstruationLength,
              ovulationStartDay: ovulationStartDay,
              // As per the image, the fertile window seems wide
              ovulationLength: 6,
            ),
            size: Size.infinite,
          ),
          // The text content in the middle
          Padding(
            padding: EdgeInsets.all(65.w), // Keep text from hitting the circle
            child: _buildCenterContent(),
          ),
        ],
      ),
    );
  }
}

class _MenstrualCyclePainter extends CustomPainter {
  final int cycleLength;
  final int currentDay;
  final int menstruationLength;
  final int ovulationStartDay;
  final int ovulationLength;

  _MenstrualCyclePainter({
    required this.cycleLength,
    required this.currentDay,
    required this.menstruationLength,
    required this.ovulationStartDay,
    required this.ovulationLength,
  });

  // Define colors based on the phases
  final Color menstruationColor = const Color(0xfff26b77);
  final Color follicularColor = const Color(0xfffce3e4);
  final Color ovulationColor = const Color(0xff70c9ba);
  final Color lutealColor = const Color(0xffdbebf0);
  final Color currentDayColor = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 40.w;
    const strokeWidth = 18.0;

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Use butt for seamless arcs

    final anglePerDay = (2 * pi) / cycleLength;
    const startAngle = -pi / 2; // Start from the top

    // --- 1. Draw Phase Arcs ---
    for (int day = 1; day <= cycleLength; day++) {
      final dayStartAngle = startAngle + (day - 1) * anglePerDay;

      // Determine color based on day
      if (day <= menstruationLength) {
        arcPaint.color = menstruationColor;
      } else if (day >= ovulationStartDay &&
          day < ovulationStartDay + ovulationLength) {
        arcPaint.color = ovulationColor;
      } else if (day > menstruationLength && day < ovulationStartDay) {
        // Follicular phase before ovulation
        arcPaint.color = follicularColor;
      } else {
        // Luteal phase
        arcPaint.color = lutealColor;
      }

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        dayStartAngle,
        anglePerDay, // Draw one day segment at a time
        false,
        arcPaint,
      );
    }

    // --- 2. Draw Day Numbers and Current Day Highlight ---
    for (int day = 1; day <= cycleLength; day++) {
      final angle = startAngle + (day - 0.5) * anglePerDay; // Center of the arc
      final offset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      // Highlight the current day
      if (day == currentDay) {
        final highlightPaint = Paint()..color = currentDayColor;
        canvas.drawCircle(offset, strokeWidth * 0.7, highlightPaint);

        final borderPaint = Paint()
          ..color = Colors.grey.shade400
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(offset, strokeWidth * 0.7, borderPaint);
      }

      // Draw the day number
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$day',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: day == currentDay ? FontWeight.bold : FontWeight.normal,
            color: day == currentDay ? Colors.black : Colors.grey.shade600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        offset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // --- 3. Draw Outer Phase Labels ---
    _drawPhaseLabel(canvas, size, "Menstruation", 0, menstruationColor);
    _drawPhaseLabel(canvas, size, "Follicular phase",
        (cycleLength ~/ 4).toDouble(), follicularColor);
    _drawPhaseLabel(canvas, size, "Ovulation", (cycleLength ~/ 2).toDouble(),
        ovulationColor);
    _drawPhaseLabel(canvas, size, "Luteal phase",
        (cycleLength * 3 / 4).toDouble(), lutealColor);
  }

  void _drawPhaseLabel(
      Canvas canvas, Size size, String label, double dayPosition, Color color) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        min(size.width / 2, size.height / 2) - 10.w; // Outer radius for labels
    final anglePerDay = (2 * pi) / cycleLength;
    final angle = -pi / 2 + (dayPosition - 0.5) * anglePerDay;

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
            fontSize: 12.sp, color: color, fontWeight: FontWeight.w500),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    // Draw text upright relative to the circle's tangent
    canvas.translate(radius, 0);
    canvas.rotate(-angle);
    // Additional rotation for side labels to keep them horizontal
    if (angle > pi / 2 || angle < -pi / 2) {
      canvas.rotate(pi); // Flip text that is upside down
    }

    textPainter.paint(
        canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MenstrualCyclePainter oldDelegate) {
    // Repaint whenever data changes
    return oldDelegate.cycleLength != cycleLength ||
        oldDelegate.currentDay != currentDay;
  }
}
