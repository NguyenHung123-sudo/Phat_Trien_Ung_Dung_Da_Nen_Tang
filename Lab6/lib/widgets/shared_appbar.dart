import 'package:flutter/material.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const SharedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEF6C00)],
        ).createShader(bounds),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFEF6C00), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
