import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class StepLabel extends StatelessWidget {
  final String number;
  final String label;

  const StepLabel({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          number,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(width: 8),
        Container(width: 12, height: 1, color: AppTheme.surfaceBorder),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String label;

  const FieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class OnboardingTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialValue;

  const OnboardingTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.maxLength,
    required this.onChanged,
    this.validator,
    this.initialValue,
  });

  @override
  State<OnboardingTextField> createState() => _OnboardingTextFieldState();
}

class _OnboardingTextFieldState extends State<OnboardingTextField> {
  late final TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) => setState(() => _isFocused = focus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: _isFocused ? AppTheme.primary : AppTheme.surfaceBorder,
            width: _isFocused ? 1.5 : 1.0,
          ),
        ),
        child: TextFormField(
          controller: _controller,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textPrimary,
            fontSize: 14,
          ),
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) => null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.spaceGrotesk(
              color: AppTheme.textMuted,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              widget.prefixIcon,
              color: _isFocused ? AppTheme.primary : AppTheme.textMuted,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMD,
              vertical: AppTheme.spaceMD,
            ),
          ),
        ),
      ),
    );
  }
}

class StepperControl extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final String suffix;
  final Color color;

  const StepperControl({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onDecrement,
    required this.onIncrement,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: value > min ? onDecrement : null,
          icon: Icon(
            Icons.remove_circle_outline_rounded,
            color: value > min ? color : AppTheme.textMuted,
            size: 24,
          ),
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 40),
          alignment: Alignment.center,
          child: Text(
            '$value$suffix',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: value < max ? onIncrement : null,
          icon: Icon(
            Icons.add_circle_outline_rounded,
            color: value < max ? color : AppTheme.textMuted,
            size: 24,
          ),
        ),
      ],
    );
  }
}
