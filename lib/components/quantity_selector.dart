import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  final double spacing;
  final bool filled;

  const QuantitySelector({
    super.key,
    this.initialValue = 1,
    required this.onChanged,
    this.spacing = 0,
    this.filled = true,
  });

  @override
  State createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _updateValue(int newValue) {
    if (newValue >= 1) { // Minimum quantity limit
      setState(() => _currentValue = newValue);
      widget.onChanged(_currentValue); // Trigger the callback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: widget.spacing,
      children: [
        widget.filled?IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            side: BorderSide(          // The border
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.remove),
          onPressed: () => _updateValue(_currentValue - 1),
        ):
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _updateValue(_currentValue - 1),
        ),
        Text('$_currentValue', style: const TextStyle(fontSize: 18)),
        widget.filled?IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            side: BorderSide(          // The border
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.add),
          onPressed: () => _updateValue(_currentValue + 1),
        ):IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _updateValue(_currentValue + 1),
        ),
      ],
    );
  }
}




