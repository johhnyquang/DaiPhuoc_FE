//import 'package:dai_phuoc_fe/views/widgets/common/custom_dropdown.dart';
import 'package:dai_phuoc_fe/views/widgets/common/custom_dropdown_search.dart';
import 'package:flutter/material.dart';

class ApiDropdown<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final T? value;
  final Future<List<T>> Function() fetchItems;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;
  final bool isRequired;
  
  const ApiDropdown({
    super.key,
    required this.label,
    this.hint,
    required this.value,
    required this.fetchItems,
    required this.itemLabel,
    required this.onChanged,
    this.prefixIcon,
    this.isRequired = false,
  });

  @override
  State<ApiDropdown<T>> createState() => _ApiDropdownState<T>();
}

class _ApiDropdownState<T> extends State<ApiDropdown<T>> {
  bool _isLoading = false;
  List<T> _items = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await widget.fetchItems();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải dữ liệu $e' ;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.prefixIcon != null 
              ? Icon(widget.prefixIcon) 
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: const [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Đang tải...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.prefixIcon != null 
              ? Icon(widget.prefixIcon) 
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadItems,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    }

    // return CustomDropdown<T>(
    //   label: widget.label,
    //   hint: widget.hint,
    //   value: widget.value,
    //   prefixIcon: widget.prefixIcon,
    //   isRequired: widget.isRequired,
    //   items: _items.map((item) {
    //     return DropdownItem<T>(
    //       value: item,
    //       label: widget.itemLabel(item),
    //     );
    //   }).toList(),
    //   onChanged: widget.onChanged,
    // );

    return CustomDropdownSearch<T>(
      label: widget.label,
      hint: widget.hint,
      selectedItem: widget.value,
      itemAsString: widget.itemLabel,
      items: _items.toList(),
      onChanged: widget.onChanged,
      prefixIcon: widget.prefixIcon,
    );
  }
}