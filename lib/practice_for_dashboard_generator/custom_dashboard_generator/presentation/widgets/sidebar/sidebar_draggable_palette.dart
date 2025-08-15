import 'package:flutter/material.dart';
import 'package:practice/practice_for_dashboard_generator/custom_dashboard_generator/models/sidebar_palette_model.dart';

class SidebarDraggablePalette extends StatelessWidget {
  const SidebarDraggablePalette({required this.paletteModel, super.key});

  final SidebarPaletteModel paletteModel;

  @override
  Widget build(BuildContext context) {
    return Draggable<SidebarPaletteModel>(
      data: paletteModel,
      feedback: _DraggableFeedback(paletteModel: paletteModel),
      child: _DraggableChild(paletteModel: paletteModel),
    );
  }
}

class _DraggableChild extends StatelessWidget {
  const _DraggableChild({required this.paletteModel, super.key});

  final SidebarPaletteModel paletteModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500.withAlpha(20), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: paletteModel.color.withValues(alpha: 0.1),
            child: Icon(paletteModel.icon, color: paletteModel.color),
          ),
          const SizedBox(width: 4),
          Expanded(child: Text(paletteModel.label)),
          const SizedBox(width: 8),
          const Icon(Icons.drag_indicator),
        ],
      ),
    );
  }
}

class _DraggableFeedback extends StatelessWidget {
  const _DraggableFeedback({required this.paletteModel, super.key});

  final SidebarPaletteModel paletteModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(paletteModel.icon),
            const SizedBox(width: 8),
            Text(paletteModel.label),
          ],
        ),
      ),
    );
  }
}
