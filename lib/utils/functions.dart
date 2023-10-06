import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_expense_tracker/utils/utils.dart';

String? validateTxtFiled({
  required String? value,
  String? field = '',
}) {
  if (value == null || value.isEmpty) {
    if (field!.isNotEmpty) {
      return '$field is required';
    }
    return 'Required';
  }
  return null;
}

String addPlusToPhoneNumber(String phoneNumber) {
  var phone = '';
  if (!phoneNumber.startsWith('+')) {
    phone = '+$phoneNumber';
  } else {
    phone = phoneNumber;
  }
  return phone;
}

String removeLettersFromString(
  String inputString,
  List<String> lettersToRemove,
) {
  var result = '';

  for (var i = 0; i < inputString.length; i++) {
    final currentChar = inputString[i];

    if (!lettersToRemove.contains(currentChar)) {
      result += currentChar;
    }
  }

  return result;
}

String getFileSizeString(int bytes, [int decimals = 0]) {
  if (bytes <= 0) return '0 Bytes';
  const suffixes = [' Bytes', 'KB', 'MB', 'GB', 'TB'];
  final i = (math.log(bytes) / math.log(1024)).floor();
  return ((bytes / math.pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}

String? validateTextField({required String? value, required String field}) {
  if (value!.isEmpty) {
    return '$field required';
  }
  return null;
}

InputDecoration kTextFieldDecoration = InputDecoration(
  isDense: false,
  // isCollapsed: false,
  hintText: 'Required',
  // border: kOutline,
  enabledBorder: kOutline,
  filled: true,
  fillColor: Theme.of(navKey.currentContext!).colorScheme.onPrimary,
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Theme.of(navKey.currentContext!).colorScheme.primary),
  ),
  hintStyle: TextStyle(
    color:
        Theme.of(navKey.currentContext!).colorScheme.secondary.withOpacity(0.4),
  ),
  contentPadding: const EdgeInsets.only(top: 16, left: 8),
  prefixIconConstraints: const BoxConstraints(minHeight: 50),
);
UnderlineInputBorder kUnderline = UnderlineInputBorder(
  borderSide: BorderSide(
    color: Theme.of(navKey.currentContext!).colorScheme.secondary,
    width: 0.5,
  ),
);
OutlineInputBorder kOutline = OutlineInputBorder(
  borderSide: BorderSide(
    color: Theme.of(navKey.currentContext!).colorScheme.secondary,
    width: 0.5,
  ),
);

TextStyle kHintStyle = TextStyle(
  fontSize: 16,
  color:
      Theme.of(navKey.currentContext!).colorScheme.secondary.withOpacity(0.4),
);
const kLabelStyle = TextStyle(
  fontSize: 16,
);
