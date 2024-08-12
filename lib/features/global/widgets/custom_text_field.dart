import 'package:flutter/material.dart';
import 'package:group_chat_app/features/global/themes/style.dart';

class CustomTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final String? hint;
  final IconData? iconData;
  final double? padding;
  final TextEditingController? controller;
  final bool? obscureText;
  const CustomTextField({
    super.key,
    this.focusNode,
    this.padding = 0,
    this.hint,
    this.iconData,
    this.controller,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hasFocus = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    (widget.focusNode!).addListener(
      () {
        setState(() {
          hasFocus = widget.focusNode!.hasFocus;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding!),
      child: TextField(
        controller: widget.controller,
        cursorColor: greenColor,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText!,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.iconData),
          prefixIconColor: hasFocus ? greenColor : Colors.grey[600],
          labelText: "${widget.hint}",
          labelStyle: hasFocus
              ? const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: greenColor,
                )
              : const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: greenColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
