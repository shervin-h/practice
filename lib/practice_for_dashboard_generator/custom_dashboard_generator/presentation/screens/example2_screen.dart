// File: dashboard_drag_drop.dart
// Step 1: Core drag & drop from a left palette onto a snap-to-grid canvas.
// - Left: a sidebar with draggable palette items
// - Right: a grid canvas (12 columns) that accepts drops and snaps to cells
// - Items can also be repositioned by dragging them inside the grid
// - Overlap prevention is NOT implemented in Step 1 (we'll add in later steps)
// - Resizing handles will be added in later steps
//
// This file can be used as a standalone demo by running `flutter run` with this as main.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A palette item that can be dragged from the left sidebar.
class PaletteItem {
  final String label;
  final IconData icon;
  final int w; // width in grid columns
  final int h; // height in grid rows
  final Color color;

  const PaletteItem({
    required this.label,
    required this.icon,
    required this.w,
    required this.h,
    required this.color,
  });
}

/// An item placed on the grid (dashboard widget instance).
class DashboardItem {
  final String id;
  int x; // column index (0-based)
  int y; // row index (0-based)
  int w; // width in columns
  int h; // height in rows
  final String label;
  final Color color;

  DashboardItem({
    required this.id,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.label,
    required this.color,
  });
}

/// Data used when dragging an existing item inside the grid.
class _MoveItemData {
  final String id;

  _MoveItemData(this.id);
}

class DashboardBuilderPage extends StatefulWidget {
  const DashboardBuilderPage({super.key});

  @override
  State<DashboardBuilderPage> createState() => _DashboardBuilderPageState();
}

class _DashboardBuilderPageState extends State<DashboardBuilderPage> {
  // Demo palette
  final _palette = const [
    PaletteItem(label: 'Line Chart', icon: Icons.show_chart, w: 4, h: 3, color: Color(0xFF4F46E5)),
    PaletteItem(label: 'Bar Chart', icon: Icons.bar_chart, w: 4, h: 4, color: Color(0xFF06B6D4)),
    PaletteItem(label: 'KPI Card', icon: Icons.speed, w: 3, h: 2, color: Color(0xFFF59E0B)),
    PaletteItem(label: 'Table', icon: Icons.table_chart, w: 6, h: 4, color: Color(0xFF10B981)),
    PaletteItem(label: 'Text', icon: Icons.text_fields, w: 4, h: 2, color: Color(0xFFE11D48)),
  ];

  // Placed items on the grid
  final List<DashboardItem> _items = [];

  // Grid config
  static const int columns = 12;
  static const double gap = 8.0; // gap between cells
  static const double baseRowHeight = 80.0; // pixel height for one row (approx)

  // Compute how many rows we need to render based on current items
  int get _computedRows {
    int maxEndRow = 8; // minimum visible rows
    for (final it in _items) {
      maxEndRow = math.max(maxEndRow, it.y + it.h + 2);
    }
    return maxEndRow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Builder – Drag & Drop (Step 1)'),
      ),
      body: Row(
        children: [
          // Left palette
          SizedBox(
            width: 260,
            child: _buildPalette(),
          ),
          const VerticalDivider(width: 1),
          // Right canvas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildCanvas(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Widget Palette', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Drag an item to the grid →'),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _palette.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final p = _palette[index];
              return _PaletteDraggableTile(item: p);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Compute grid metrics
        final totalWidth = constraints.maxWidth;
        final unit = _GridUnit.from(totalWidth, columns: columns, gap: gap);
        final rowHeight = baseRowHeight; // could be responsive later

        // The canvas height grows with content; make it scrollable vertically
        final canvasHeight = _computedRows * rowHeight + (_computedRows - 1) * gap;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Scrollable area showing grid + items
                SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: canvasHeight + 24, // extra breathing room at bottom
                    child: Stack(
                      children: [
                        // Grid background
                        CustomPaint(
                          size: Size(double.infinity, canvasHeight),
                          painter: _GridPainter(
                            columns: columns,
                            rows: _computedRows,
                            unit: unit,
                            rowHeight: rowHeight,
                            gap: gap,
                            dividerColor: Theme.of(context).dividerColor.withOpacity(0.6),
                          ),
                        ),
                        // Drag target overlay spanning the whole grid
                        Positioned.fill(
                          child: DragTarget(
                            onWillAccept: (data) => true,
                            onAcceptWithDetails: (details) {
                              final rb = context.findRenderObject() as RenderBox?;
                              if (rb == null) return;
                              final local = rb.globalToLocal(details.offset);

                              // Convert pointer offset to grid cell (x,y)
                              int cx = (local.dx / (unit.cell + gap)).floor();
                              int cy = (local.dy / (rowHeight + gap)).floor();
                              cx = cx.clamp(0, columns - 1);
                              cy = math.max(0, cy);

                              if (details.data is PaletteItem) {
                                final p = details.data as PaletteItem;
                                final w = p.w.clamp(1, columns);
                                final h = math.max(1, p.h);
                                // Clamp to keep inside canvas width
                                cx = cx.clamp(0, columns - w);

                                setState(() {
                                  _items.add(
                                    DashboardItem(
                                      id: UniqueKey().toString(),
                                      x: cx,
                                      y: cy,
                                      w: w,
                                      h: h,
                                      label: p.label,
                                      color: p.color,
                                    ),
                                  );
                                });
                              } else if (details.data is _MoveItemData) {
                                final move = details.data as _MoveItemData;
                                final idx = _items.indexWhere((e) => e.id == move.id);
                                if (idx != -1) {
                                  final w = _items[idx].w;
                                  cx = cx.clamp(0, columns - w);
                                  setState(() {
                                    _items[idx].x = cx;
                                    _items[idx].y = cy;
                                  });
                                }
                              }
                            },
                            builder: (context, candidate, rejected) {
                              // Render placed items (top of grid background)
                              return Stack(
                                  children: _items.map((it) {
                                final left = it.x * (unit.cell + gap);
                                final top = it.y * (rowHeight + gap);
                                final w = it.w * unit.cell + (it.w - 1) * gap;
                                final h = it.h * rowHeight + (it.h - 1) * gap;
                                return Positioned(
                                  left: left,
                                  top: top,
                                  width: w,
                                  height: h,
                                  child: _GridItem(
                                    item: it,
                                    onRemove: () {
                                      setState(() => _items.removeWhere((e) => e.id == it.id));
                                    },
                                  ),
                                );
                              }).toList());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sticky header help text
                Positioned(
                  left: 16,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ],
                    ),
                    child: const Text('Drop widgets here • Snaps to grid'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PaletteDraggableTile extends StatelessWidget {
  final PaletteItem item;

  const _PaletteDraggableTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Draggable<PaletteItem>(
      data: item,
      feedback: _PaletteChip(label: item.label, icon: item.icon),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _PaletteTile(item: item),
      ),
      child: _PaletteTile(item: item),
    );
  }
}

class _PaletteTile extends StatelessWidget {
  final PaletteItem item;

  const _PaletteTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: item.color.withOpacity(0.2), child: Icon(item.icon, color: item.color)),
        title: Text(item.label),
        subtitle: Text('${item.w}×${item.h} cells'),
        trailing: const Icon(Icons.drag_indicator),
      ),
    );
  }
}

class _PaletteChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PaletteChip({required this.label, required this.icon});

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final DashboardItem item;
  final VoidCallback onRemove;

  const _GridItem({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: _MoveItemData(item.id),
      feedback: Opacity(
        opacity: 0.9,
        child: _GridItemCard(item: item, dragging: true),
      ),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      childWhenDragging: const SizedBox.expand(),
      child: _GridItemCard(item: item),
    );
  }
}

class _GridItemCard extends StatelessWidget {
  final DashboardItem item;
  final bool dragging;

  const _GridItemCard({required this.item, this.dragging = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: dragging ? 16 : 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [item.color.withOpacity(0.12), item.color.withOpacity(0.04)],
          ),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Stack(
          children: [
            // Placeholder content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.widgets, color: item.color),
                  const SizedBox(height: 8),
                  Text(item.label, style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface)),
                  const SizedBox(height: 4),
                  Text('Size: ${item.w}×${item.h}  •  Pos: ${item.x},${item.y}',
                      style: TextStyle(color: cs.onSurfaceVariant)),
                ],
              ),
            ),

            // Small remove button (top-right)
            Positioned(
              right: 8,
              top: 8,
              child: InkWell(
                onTap: dragging ? null : () {} , // onRemove,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Icon(Icons.close, size: 16, color: cs.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridUnit {
  final double cell;

  const _GridUnit(this.cell);

  factory _GridUnit.from(double totalWidth, {required int columns, required double gap}) {
    final totalGaps = (columns - 1) * gap;
    final cell = (totalWidth - totalGaps - 24 /*canvas padding horizontal inside*/ - 2 /*border fudge*/) / columns;
    return _GridUnit(cell);
  }
}

class _GridPainter extends CustomPainter {
  final int columns;
  final int rows;
  final _GridUnit unit;
  final double rowHeight;
  final double gap;
  final Color dividerColor;

  _GridPainter({
    required this.columns,
    required this.rows,
    required this.unit,
    required this.rowHeight,
    required this.gap,
    required this.dividerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw column guides
    for (int c = 0; c <= columns; c++) {
      final x = c * (unit.cell + gap) - (c == 0 ? 0 : gap);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw row guides
    for (int r = 0; r <= rows; r++) {
      final y = r * (rowHeight + gap) - (r == 0 ? 0 : gap);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.columns != columns ||
        oldDelegate.rows != rows ||
        oldDelegate.unit.cell != unit.cell ||
        oldDelegate.rowHeight != rowHeight ||
        oldDelegate.gap != gap ||
        oldDelegate.dividerColor != dividerColor;
  }
}
