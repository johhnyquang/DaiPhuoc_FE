import 'package:dai_phuoc_fe/views/widgets/common/custom_dropdown.dart';
import 'package:flutter/material.dart';

class DropdownConstant {
  static const List<DropdownItem<bool>> genders = [
    DropdownItem(
      value: true,
      label: 'Nam',
      icon: Icons.male,
    ),
    DropdownItem(
      value: false,
      label: 'Nữ',
      icon: Icons.female,
    )
  ];
}