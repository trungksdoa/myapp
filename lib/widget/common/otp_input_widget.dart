import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/core/colors.dart';

class OTPInputWidget extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final TextEditingController? controller;
  final bool enabled;

  const OTPInputWidget({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.controller,
    this.enabled = true,
  });

  @override
  State<OTPInputWidget> createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleOTPChange(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1 && widget.enabled) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0 && widget.enabled) {
      _focusNodes[index - 1].requestFocus();
    }

    // Check if all OTP fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final otp = _controllers.map((controller) => controller.text).join();
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 60,
          height: 60,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            enabled: widget.enabled,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
              ),
              filled: true,
              fillColor: widget.enabled
                  ? Colors.grey.shade50
                  : Colors.grey.shade100,
            ),
            onChanged: (value) => _handleOTPChange(value, index),
          ),
        );
      }),
    );
  }
}
