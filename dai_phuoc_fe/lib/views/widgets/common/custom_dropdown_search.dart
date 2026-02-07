import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? selectedItem;
  final List<T> items;
  final String Function(T) itemAsString;
  final ValueChanged<T?> onChanged;
  final String Function(T?)? validator;
  final bool enabled;
  final IconData? prefixIcon;
  final bool isRequired;

  CustomDropdownSearch({
    super.key,
    required this.label,
    this.hint,
    required this.selectedItem,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.isRequired = false
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      selectedItem: selectedItem,
      items: items,
      itemAsString: itemAsString,
      onChanged: enabled ? onChanged : null,
      enabled: enabled,

      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm ...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
            ) 
          )
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            selected: isSelected,
            title: Text(itemAsString(item)),
            trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue,) : null,
          );
        },
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(12),
          elevation: 8
        )
      ),

      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          enabled: enabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2)
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)
          )
        )
      ),

      validator: validator,
    );
  }
}