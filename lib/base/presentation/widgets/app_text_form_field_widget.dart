import 'dart:async';

import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.title,
    this.hintText,
    this.onTapOutside,
    this.autovalidateMode,
    this.validator,
    this.debounceDuration,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final String? title;
  final String? hintText;
  final TapRegionCallback? onTapOutside;
  final AutovalidateMode? autovalidateMode;
  final FormFieldValidator<String>? validator;
  final Duration? debounceDuration;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  Timer? _debounceTimer;

  void _handleChanged(String value) {
    if (widget.debounceDuration != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceDuration!, () {
        widget.onChanged?.call(value);
      });
    } else {
      widget.onChanged?.call(value);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      initialValue: widget.initialValue,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(border: const OutlineInputBorder(), hintText: widget.hintText),
      onChanged: _handleChanged,
      onTapOutside: widget.onTapOutside ?? (_) => context.hideKeyboard(),
    );

    return widget.title == null
        ? field
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(widget.title!, style: context.texts.labelLarge),
              field,
            ],
          );
  }
}
