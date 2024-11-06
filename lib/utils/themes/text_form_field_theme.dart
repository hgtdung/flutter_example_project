import 'package:flutter/material.dart';
import 'package:flutter_example_project/utils/themes/app_color.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
    errorStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.red),
    border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.orange80)),
    enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.orange80)),
    errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.red)),
    focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.orange80)),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.red)),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
    errorStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.red),
    border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.orange80)),
    enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.orange80)),
    errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.red)),
    focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.orange80)),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: AppColors.red)),
  );
}
