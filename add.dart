import 'package:flutter/material.dart';

// ============================================================
//  ats_dropdown.dart
//  Shared _AtsDropdown widget — use across ALL screens.
//
//  IMPORT in any screen:
//  import 'ats_dropdown.dart';
//
//  USAGE:
//  AtsDropdown(
//    value: _selectedValue,
//    hint: 'Select an option...',
//    items: ['Option A', 'Option B'],
//    onChanged: (v) => setState(() => _selectedValue = v),
//  )
// ============================================================

// ── Design tokens (match rest of ATS app) ──────────────────
const Color _kBlue      = Color(0xFF1A73E8);
const Color _kNavy      = Color(0xFF1E2A3A);
const Color _kSurface   = Color(0xFFF5F7FA);
const Color _kBorder    = Color(0xFFDDE3EE);
const Color _kTextMain  = Color(0xFF1E2A3A);
const Color _kTextMuted = Color(0xFF6B7280);
const Color _kTextLight = Color(0xFF9AA0A6);

// ── Shared sizes ───────────────────────────────────────────
const double _kPopupWidth   = 340; // consistent popup width
const double _kPopupMaxH    = 260; // max popup height
const double _kItemHeight   = 44;  // each option row height
const double _kSearchHeight = 40;  // search bar height

// ============================================================
//  _AtsDropdown — main widget
// ============================================================
class AtsDropdown extends StatefulWidget {
  final String?               value;
  final String                hint;
  final List<String>          items;
  final void Function(String?) onChanged;
  final IconData?             prefixIcon;

  const AtsDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  State<AtsDropdown> createState() => AtsDropdownState();
}

class AtsDropdownState extends State<AtsDropdown> {
  bool _isOpen = false;

  void _toggle() => setState(() => _isOpen = !_isOpen);
  void _close()  => setState(() => _isOpen = false);

  void _select(String? val) {
    widget.onChanged(val);
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // ── Trigger field ───────────────────────────────────
        GestureDetector(
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isOpen
                    ? _kBlue
                    : hasValue
                        ? _kBlue.withOpacity(0.4)
                        : _kBorder,
                width: _isOpen ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    size: 15,
                    color: _isOpen ? _kBlue : _kTextMuted,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.value ?? widget.hint,
                    style: TextStyle(
                      fontSize: 13,
                      color: hasValue
                          ? _kTextMain
                          : _kTextMuted.withOpacity(0.65),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Clear + chevron
                if (hasValue)
                  GestureDetector(
                    onTap: () {
                      _select(null);
                      setState(() {});
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.close,
                          size: 13, color: _kTextMuted),
                    ),
                  ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: const Icon(Icons.keyboard_arrow_down,
                      size: 16, color: _kTextMuted),
                ),
              ],
            ),
          ),
        ),

        // ── Inline popup panel ──────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SizeTransition(
                sizeFactor: anim, axisAlignment: -1, child: child),
          ),
          child: _isOpen
              ? AtsDropdownPanel(
                  key: const ValueKey('panel'),
                  items: widget.items,
                  selected: widget.value,
                  onSelect: _select,
                  showSearch: widget.items.length > 6,
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}

// ============================================================
//  _AtsDropdownPanel — the scrollable list panel
// ============================================================
class AtsDropdownPanel extends StatefulWidget {
  final List<String>          items;
  final String?               selected;
  final void Function(String?) onSelect;
  final bool                  showSearch;

  const AtsDropdownPanel({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
    required this.showSearch,
  });

  @override
  State<AtsDropdownPanel> createState() => AtsDropdownPanelState();
}

class AtsDropdownPanelState extends State<AtsDropdownPanel> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> get _filtered {
    if (_query.isEmpty) return widget.items;
    return widget.items
        .where((i) => i.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Container(
      margin: const EdgeInsets.only(top: 5),
      width: double.infinity,
      constraints: const BoxConstraints(
        minWidth: _kPopupWidth,
        maxHeight: _kPopupMaxH,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Search bar (shown when > 6 items) ────────────
            if (widget.showSearch) ...[
              Container(
                height: _kSearchHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: _kBorder)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 15, color: _kTextLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        autofocus: false,
                        style: const TextStyle(
                            fontSize: 12.5, color: _kTextMain),
                        onChanged: (v) =>
                            setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: _kTextLight),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  vertical: 8),
                        ),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                        child: const Icon(Icons.close,
                            size: 13, color: _kTextLight),
                      ),
                  ],
                ),
              ),
            ],

            // ── Options list ─────────────────────────────────
            Flexible(
              child: filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4),
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) =>
                          AtsDropdownItem(
                            label: filtered[i],
                            isSelected:
                                widget.selected == filtered[i],
                            onTap: () =>
                                widget.onSelect(filtered[i]),
                          ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return SizedBox(
      height: 80,
      child: Center(
        child: Text(
          'No results for "$_query"',
          style: const TextStyle(
              fontSize: 12, color: _kTextLight),
        ),
      ),
    );
  }
}

// ============================================================
//  _AtsDropdownItem — single row with hover + selected states
// ============================================================
class AtsDropdownItem extends StatefulWidget {
  final String    label;
  final bool      isSelected;
  final VoidCallback onTap;

  const AtsDropdownItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AtsDropdownItem> createState() => AtsDropdownItemState();
}

class AtsDropdownItemState extends State<AtsDropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: _kItemHeight,
          margin: const EdgeInsets.symmetric(
              horizontal: 6, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? _kBlue.withOpacity(0.10)
                : _hovered
                    ? _kSurface
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: widget.isSelected
                ? Border.all(
                    color: _kBlue.withOpacity(0.30), width: 1)
                : null,
          ),
          child: Row(
            children: [
              // Radio circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? _kBlue
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected
                        ? _kBlue
                        : _kBorder,
                    width: 1.5,
                  ),
                ),
                child: widget.isSelected
                    ? const Icon(Icons.check,
                        size: 10, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),

              // Label
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: widget.isSelected
                        ? _kBlue
                        : _hovered
                            ? _kTextMain
                            : _kTextMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Hover arrow
              if (_hovered && !widget.isSelected)
                const Icon(Icons.chevron_right,
                    size: 14, color: _kTextLight),
            ],
          ),
        ),
      ),
    );
  }
}
