import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  const CircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _buildIcon(),
      onPressed: widget.onPressed,
    );
  }

  Widget _buildIcon() {
    return Container(
      decoration: _buildButtonDecoration(),
      padding: const EdgeInsets.all(4),
      child: Icon(
        widget.icon,
        size: 28,
        color: _iconColor(),
      ),
    );
  }

  BoxDecoration _buildButtonDecoration() {
    return const BoxDecoration(
      color: Color.fromARGB(153, 250, 250, 250),
      shape: BoxShape.circle,
    );
  }

  Color _iconColor() {
    return const Color.fromRGBO(0, 104, 178, 1);
  }
}
