import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? labelText; // Optional labelText property

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    required this.obscureText,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            labelStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey)
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
          ),
          validator: validator,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final List<String> items;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.items,
    this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 350,
          child: DropdownButtonFormField<String>(
            value: controller.text.isEmpty ? null : controller.text,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
              hintStyle: TextStyle(color: Colors.grey[400]),
              hintText: null,
              filled: true,
              fillColor: const Color.fromARGB(255, 250, 244, 228),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.grey)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 228, 223, 223),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 13, 13, 13),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Color.fromARGB(255, 35, 94, 77),
            ),
            hint: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                hintText,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Container(
                  width: 200,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                controller.text = value;
              }
            },
            dropdownColor: const Color.fromARGB(255, 250, 244, 228),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class CustomMultiSelectDropdown extends StatelessWidget {
  final TextEditingController controller;
  final Function(List<String>) onSelect;
  final String hintText;
  final IconData? prefixIcon;
  final List<String> items;

  const CustomMultiSelectDropdown({
    Key? key,
    required this.controller,
    required this.onSelect,
    required this.hintText,
    required this.items,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            List<String>? selectedItems = await showDialog(
              context: context,
              builder: (context) => MultiSelectDialog(
                items: items,
                selectedItems:
                    controller.text.isEmpty ? [] : controller.text.split(', '),
              ),
            );

            if (selectedItems != null) {
              // Update the controller text
              // controller.text = selectedItems.join(', ');
              onSelect(selectedItems);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 244, 228),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? hintText : controller.text,
                    style: TextStyle(
                      color: controller.text.isEmpty
                          ? Colors.grey[900]
                          : Colors.black,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: const Color.fromARGB(255, 35, 94, 77),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;

  const MultiSelectDialog({
    Key? key,
    required this.items,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Interests'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.items.map((item) {
            return CheckboxListTile(
              title: Text(item),
              value: _selectedItems.contains(item),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedItems.add(item);
                  } else {
                    _selectedItems.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _selectedItems),
          child: Text('OK'),
        ),
      ],
    );
  }
}
