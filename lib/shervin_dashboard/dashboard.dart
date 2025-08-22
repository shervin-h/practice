import 'package:flutter/material.dart';

/// =======================
/// Dashboard Grid (Web/Desktop/Mobile friendly)
/// - Snap-to-grid drag & drop (move)
/// - Real-time resize from all edges/corners
/// - Collision/bounds aware (stop at neighbors, revert on invalid drop)
/// - Works on Flutter Web & Windows/macOS/Linux & Mobile
/// =======================

class GridDemoPage extends StatefulWidget {
  const GridDemoPage({super.key});

  @override
  State<GridDemoPage> createState() => _GridDemoPageState();
}

class _GridDemoPageState extends State<GridDemoPage> {
  final _v = ScrollController();
  final _h = ScrollController();

  late List<DashItem> items;

  @override
  void initState() {
    super.initState();
    items = [
      DashItem(id: 'a', x: 0, y: 0, w: 3, h: 3, child: _card('A')),
      DashItem(id: 'b', x: 4, y: 1, w: 4, h: 3, child: _card('B')),
      DashItem(id: 'c', x: 2, y: 5, w: 5, h: 4, child: _card('C')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const cols = 12;
    const rows = 16;
    const cell = 88.0; // px
    const gap = 8.0; // px
    const pad = EdgeInsets.all(16);

    final math = GridMath(cellSize: cell, gap: gap, padding: pad);

    final contentSize = Size(
      math.gridWidthPx(cols),
      math.gridHeightPx(rows),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Grid (Drag + Resize)')),
      body: Scrollbar(
        controller: _v,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _v,
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            controller: _h,
            thumbVisibility: true,
            notificationPredicate: (notif) => notif.metrics.axis == Axis.horizontal,
            child: SingleChildScrollView(
              controller: _h,
              scrollDirection: Axis.horizontal,
              primary: false,
              child: SizedBox(
                width: contentSize.width,
                height: contentSize.height,
                child: _DashboardBoard(
                  columns: cols,
                  rows: rows,
                  math: math,
                  items: items,
                  onItemsChanged: (newItems) => setState(() => items = newItems),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _card(String title) => Container(
    color: const Color(0xFFFDFDFE),
    child: Center(
      child: Text(
        'Box $title',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

/// ======================= DATA & MATH =======================

class DashItem {
  final String id;
  int x, y, w, h; // grid-units
  final Widget child;

  DashItem({
    required this.id,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.child,
  });

  DashItem copy() => DashItem(id: id, x: x, y: y, w: w, h: h, child: child);
  RectInt get rect => RectInt(x, y, w, h);
}

class RectInt {
  final int x, y, w, h;
  const RectInt(this.x, this.y, this.w, this.h);
  int get right => x + w;
  int get bottom => y + h;
  bool overlaps(RectInt o) => x < o.right && right > o.x && y < o.bottom && bottom > o.y;
}

class GridMath {
  final double cellSize;
  final double gap;
  final EdgeInsets padding;
  const GridMath({required this.cellSize, required this.gap, required this.padding});

  double get stride => cellSize + gap;

  double gridWidthPx(int columns) => padding.left + columns * cellSize + (columns - 1) * gap + padding.right;
  double gridHeightPx(int rows) => padding.top + rows * cellSize + (rows - 1) * gap + padding.bottom;

  Rect rectFor(int x, int y, int w, int h) {
    final dx = padding.left + x * stride;
    final dy = padding.top + y * stride;
    final width = w * cellSize + (w - 1) * gap;
    final height = h * cellSize + (h - 1) * gap;
    return Rect.fromLTWH(dx, dy, width, height);
  }
}

/// ======================= BOARD (grid + items) =======================

class _DashboardBoard extends StatefulWidget {
  const _DashboardBoard({
    required this.columns,
    required this.rows,
    required this.math,
    required this.items,
    required this.onItemsChanged,
  });

  final int columns;
  final int rows;
  final GridMath math;
  final List<DashItem> items;
  final ValueChanged<List<DashItem>> onItemsChanged;

  @override
  State<_DashboardBoard> createState() => _DashboardBoardState();
}

class _DashboardBoardState extends State<_DashboardBoard> {
  late List<DashItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items.map((e) => e.copy()).toList();
  }

  @override
  void didUpdateWidget(covariant _DashboardBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.items, widget.items)) {
      _items = widget.items.map((e) => e.copy()).toList();
    }
  }

  bool _regionFree(RectInt region, {String? ignore}) {
    if (region.x < 0 || region.y < 0) return false;
    if (region.right > widget.columns || region.bottom > widget.rows) return false;
    for (final it in _items) {
      if (ignore != null && it.id == ignore) continue;
      if (region.overlaps(it.rect)) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final dpr = View.of(context).devicePixelRatio;

    return Stack(
      children: [
        // grid
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(
              columns: widget.columns,
              rows: widget.rows,
              math: widget.math,
              dpr: dpr,
              strokeColor: const Color(0xFFE0E3E8),
            ),
          ),
        ),

        // items
        ..._items.map((it) => _GridItem(
          key: ValueKey(it.id),
          item: it,
          math: widget.math,
          columns: widget.columns,
          rows: widget.rows,
          isFree: (r) => _regionFree(r, ignore: it.id),
          onCommit: (updated) {
            setState(() {
              final idx = _items.indexWhere((e) => e.id == updated.id);
              if (idx != -1) _items[idx] = updated;
            });
            widget.onItemsChanged(_items.map((e) => e.copy()).toList());
          },
        )),
      ],
    );
  }
}

/// ======================= ITEM (move + resize) =======================

class _GridItem extends StatefulWidget {
  const _GridItem({
    super.key,
    required this.item,
    required this.math,
    required this.columns,
    required this.rows,
    required this.isFree,
    required this.onCommit,
  });

  final DashItem item;
  final GridMath math;
  final int columns;
  final int rows;
  final bool Function(RectInt) isFree; // occupancy check excluding self
  final ValueChanged<DashItem> onCommit; // when move/resize finalized or updated

  @override
  State<_GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<_GridItem> {
  late DashItem _cur; // current live state while dragging/resizing
  late DashItem _start; // snapshot at gesture start
  Offset _moveAccum = Offset.zero; // px accumulator → grid steps

  @override
  void initState() {
    super.initState();
    _cur = widget.item.copy();
    _start = widget.item.copy();
  }

  @override
  void didUpdateWidget(covariant _GridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cur = widget.item.copy();
  }

  Rect get _pxRect => widget.math.rectFor(_cur.x, _cur.y, _cur.w, _cur.h);

  // ---------------- Move ----------------
  void _onMoveStart(DragStartDetails d) {
    _start = _cur.copy();
    _moveAccum = Offset.zero;
  }

  void _onMoveUpdate(DragUpdateDetails d) {
    _moveAccum += d.delta;
    final dxCells = (_moveAccum.dx / widget.math.stride).round();
    final dyCells = (_moveAccum.dy / widget.math.stride).round();

    int nx = (_start.x + dxCells).clamp(0, widget.columns - _cur.w);
    int ny = (_start.y + dyCells).clamp(0, widget.rows - _cur.h);

    final candidate = RectInt(nx, ny, _cur.w, _cur.h);
    if (widget.isFree(candidate)) {
      setState(() {
        _cur
          ..x = nx
          ..y = ny;
      });
      widget.onCommit(_cur.copy()); // real-time commit (snap feeling on web)
    }
    // اگر آزاد نبود، حرکت نمی‌کنیم (جای آخر آزاد باقی می‌ماند)
  }

  void _onMoveEnd(DragEndDetails d) {
    // اگر در طول درگ به خاطر تداخل جابه‌جا نشده بود، به وضعیت شروع برگردانیم
    final ok = widget.isFree(_cur.rect);
    if (!ok) {
      setState(() => _cur = _start.copy());
      widget.onCommit(_cur.copy());
    }
  }

  // ---------------- Resize helpers ----------------

  int _maxGrowRight() {
    int limit = widget.columns - _cur.x; // inclusive bound as width
    // scan to the right in rows overlapped
    for (int step = _cur.w + 1; step <= limit; step++) {
      if (!widget.isFree(RectInt(_cur.x, _cur.y, step, _cur.h))) {
        return step - 1;
      }
    }
    return limit;
  }

  int _maxGrowDown() {
    int limit = widget.rows - _cur.y;
    for (int step = _cur.h + 1; step <= limit; step++) {
      if (!widget.isFree(RectInt(_cur.x, _cur.y, _cur.w, step))) {
        return step - 1;
      }
    }
    return limit;
  }

  int _maxGrowLeft() {
    int maxCells = _cur.x; // how many cells we can extend to the left
    for (int step = 1; step <= maxCells; step++) {
      final nx = _cur.x - step;
      final nw = _cur.w + step;
      if (!widget.isFree(RectInt(nx, _cur.y, nw, _cur.h))) {
        return step - 1;
      }
    }
    return maxCells;
  }

  int _maxGrowUp() {
    int maxCells = _cur.y;
    for (int step = 1; step <= maxCells; step++) {
      final ny = _cur.y - step;
      final nh = _cur.h + step;
      if (!widget.isFree(RectInt(_cur.x, ny, _cur.w, nh))) {
        return step - 1;
      }
    }
    return maxCells;
  }

  void _resizeFrom({bool l = false, bool r = false, bool t = false, bool b = false, required Offset delta}) {
    // delta in pixels → grid steps
    final dx = (delta.dx / widget.math.stride);
    final dy = (delta.dy / widget.math.stride);

    int nx = _cur.x;
    int ny = _cur.y;
    int nw = _cur.w;
    int nh = _cur.h;

    if (r) {
      final desired = (nw + dx.round());
      final maxW = _maxGrowRight();
      nw = desired.clamp(1, maxW);
    }
    if (b) {
      final desired = (nh + dy.round());
      final maxH = _maxGrowDown();
      nh = desired.clamp(1, maxH);
    }
    if (l) {
      final steps = dx.round();
      if (steps >= 0) {
        // shrinking from left
        final shrink = steps.clamp(0, nw - 1);
        nx = nx + shrink;
        nw = nw - shrink;
      } else {
        // growing to left
        final grow = (-steps).clamp(0, _maxGrowLeft());
        nx = nx - grow;
        nw = nw + grow;
      }
    }
    if (t) {
      final steps = dy.round();
      if (steps >= 0) {
        final shrink = steps.clamp(0, nh - 1);
        ny = ny + shrink;
        nh = nh - shrink;
      } else {
        final grow = (-steps).clamp(0, _maxGrowUp());
        ny = ny - grow;
        nh = nh + grow;
      }
    }

    // Apply if free
    if (widget.isFree(RectInt(nx, ny, nw, nh))) {
      setState(() {
        _cur
          ..x = nx
          ..y = ny
          ..w = nw
          ..h = nh;
      });
      widget.onCommit(_cur.copy());
    }
  }

  @override
  Widget build(BuildContext context) {
    final rect = _pxRect;

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: MouseRegion(
        cursor: SystemMouseCursors.move,
        child: Stack(
          children: [
            // body + move gesture
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: _onMoveStart,
                onPanUpdate: _onMoveUpdate,
                onPanEnd: _onMoveEnd,
                child: Material(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFF4F86F7), width: 1.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.item.child,
                  ),
                ),
              ),
            ),

            // Corner handles
            _cornerHandle(Alignment.topLeft, (d) => _resizeFrom(l: true, t: true, delta: d), SystemMouseCursors.resizeUpLeftDownRight),
            _cornerHandle(Alignment.topRight, (d) => _resizeFrom(r: true, t: true, delta: d), SystemMouseCursors.resizeUpRightDownLeft),
            _cornerHandle(Alignment.bottomLeft, (d) => _resizeFrom(l: true, b: true, delta: d), SystemMouseCursors.resizeUpRightDownLeft),
            _cornerHandle(Alignment.bottomRight, (d) => _resizeFrom(r: true, b: true, delta: d), SystemMouseCursors.resizeUpLeftDownRight),

            // Edge handles
            _edgeHandle(Alignment.centerLeft, (d) => _resizeFrom(l: true, delta: d), SystemMouseCursors.resizeLeftRight, width: 10, height: rect.height),
            _edgeHandle(Alignment.centerRight, (d) => _resizeFrom(r: true, delta: d), SystemMouseCursors.resizeLeftRight, width: 10, height: rect.height),
            _edgeHandle(Alignment.topCenter, (d) => _resizeFrom(t: true, delta: d), SystemMouseCursors.resizeUpDown, width: rect.width, height: 10),
            _edgeHandle(Alignment.bottomCenter, (d) => _resizeFrom(b: true, delta: d), SystemMouseCursors.resizeUpDown, width: rect.width, height: 10),
          ],
        ),
      ),
    );
  }

  Widget _cornerHandle(Alignment align, ValueChanged<Offset> onDelta, MouseCursor cursor) {
    return Align(
      alignment: align,
      child: MouseRegion(
        cursor: cursor,
        hitTestBehavior: HitTestBehavior.deferToChild,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (d) => onDelta(d.delta),
          child: Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFF4F86F7),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _edgeHandle(
      Alignment align,
      ValueChanged<Offset> onDelta,
      MouseCursor cursor, {
        double width = 10,
        double height = 10,
      }) {
    return Align(
      alignment: align,
      child: MouseRegion(
        cursor: cursor,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (d) => onDelta(d.delta),
          child: SizedBox(width: width, height: height),
        ),
      ),
    );
  }
}

/// ======================= GRID PAINTER =======================

class _GridPainter extends CustomPainter {
  final int columns;
  final int rows;
  final GridMath math;
  final double dpr;
  final Color strokeColor;

  _GridPainter({
    required this.columns,
    required this.rows,
    required this.math,
    required this.dpr,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / dpr
      ..color = strokeColor;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        final rect = math.rectFor(c, r, 1, 1).deflate(0.5 / dpr);
        canvas.drawRect(rect, stroke);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      columns != oldDelegate.columns ||
          rows != oldDelegate.rows ||
          math.cellSize != oldDelegate.math.cellSize ||
          math.gap != oldDelegate.math.gap ||
          math.padding != oldDelegate.math.padding ||
          strokeColor != oldDelegate.strokeColor ||
          dpr != oldDelegate.dpr;
}
