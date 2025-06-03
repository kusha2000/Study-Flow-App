import 'package:flutter/material.dart';

class CourseInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool obscureText;
  final int? maxLines;

  const CourseInputField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.validator,
      this.prefixIcon,
      this.obscureText = false,
      this.maxLines});

  @override
  State<CourseInputField> createState() => _CourseInputFieldState();
}

class _CourseInputFieldState extends State<CourseInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconScaleAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Background with elevation effect
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  boxShadow: [
                    if (_isFocused && !_hasError)
                      BoxShadow(
                        color: primaryColor.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    if (_hasError)
                      BoxShadow(
                        color: Colors.red.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                  ],
                ),
              ),

              TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                maxLines: widget.maxLines ?? 1,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    color: _isFocused
                        ? primaryColor
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: ScaleTransition(
                            scale: _iconScaleAnimation,
                            child: Icon(
                              widget.prefixIcon,
                              color: _isFocused
                                  ? primaryColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                              size: 22,
                            ),
                          ),
                        )
                      : null,
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 50,
                    minHeight: 50,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.red.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.red.shade400, width: 2),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  filled: true,
                  fillColor: _isFocused
                      ? Colors.white
                      : Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.3),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 20.0),
                  errorStyle: const TextStyle(
                    fontSize: 0, // Hide error text as we'll show it separately
                    height: 0,
                  ),
                ),
                validator: (value) {
                  final error = widget.validator?.call(value);

                  // Update error state
                  if (mounted) {
                    setState(() {
                      _hasError = error != null;
                      _errorText = error;
                    });
                  }

                  return error;
                },
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Custom error message with animation
          if (_hasError && _errorText != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(top: 8, left: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade400,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _errorText!,
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
