import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/todo_model.dart';

/// TodoCard - Widget hiển thị một todo item trong ListView
/// Hỗ trợ: toggle hoàn thành, sửa, xóa
/// Vuốt PHẢI → Sửa | Vuốt TRÁI → Xóa (flutter_slidable)
class TodoCard extends StatefulWidget {
  final TodoModel todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;
    final isCompleted = todo.isCompleted;

    return Slidable(
      key: ValueKey(todo.id),
      // ── Vuốt PHẢI → Sửa ──────────────────────────
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => widget.onEdit(),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: 'Sửa',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
        ],
      ),
      // ── Vuốt TRÁI → Xóa ──────────────────────────
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        dismissible: DismissiblePane(onDismissed: widget.onDelete),
        children: [
          SlidableAction(
            onPressed: (_) => widget.onDelete(),
            backgroundColor: const Color(0xFFE94560),
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Xóa',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ],
      ),
      // ── Card chính ───────────────────────────────
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTapDown: (_) => _controller.reverse(),
          onTapUp: (_) => _controller.forward(),
          onTapCancel: () => _controller.forward(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.white.withOpacity(0.03)
                  : Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? Colors.white.withOpacity(0.06)
                    : Colors.white.withOpacity(0.12),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // ── Left accent bar ──────────────────
                    Container(
                      width: 4,
                      color: isCompleted
                          ? Colors.green.shade400
                          : const Color(0xFFE94560),
                    ),

                    // ── Checkbox ─────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GestureDetector(
                        onTap: widget.onToggle,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? Colors.green.shade400
                                : Colors.transparent,
                            border: Border.all(
                              color: isCompleted
                                  ? Colors.green.shade400
                                  : Colors.white54,
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 16)
                              : null,
                        ),
                      ),
                    ),

                    // ── Content ──────────────────────────
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.title,
                              style: TextStyle(
                                color: isCompleted
                                    ? Colors.white38
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: Colors.white38,
                              ),
                            ),
                            if (todo.description != null &&
                                todo.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                todo.description!,
                                style: TextStyle(
                                  color: isCompleted
                                      ? Colors.white24
                                      : Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: Colors.white24,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    size: 11,
                                    color: Colors.white.withOpacity(0.3)),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(todo.createdAt),
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontSize: 11),
                                ),
                                if (isCompleted) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Hoàn thành',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Action buttons (tap) ──────────────
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _actionBtn(
                          icon: Icons.edit_outlined,
                          color: Colors.blue.shade300,
                          onTap: widget.onEdit,
                        ),
                        const SizedBox(height: 4),
                        _actionBtn(
                          icon: Icons.delete_outline_rounded,
                          color: const Color(0xFFE94560),
                          onTap: widget.onDelete,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }
}
