import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  final String currentCategory;
  final bool currentAvailableOnly;
  final Function(String category, bool availableOnly) onApplyFilters;

  const FilterDrawer({
    super.key,
    required this.currentCategory,
    required this.currentAvailableOnly,
    required this.onApplyFilters,
  });

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  // Temporary state holders for the drawer inputs
  late String _tempCategory;
  late bool _tempAvailableOnly;

  @override
  void initState() {
    super.initState();
    // Initialize state with current active values passed from parent
    _tempCategory = widget.currentCategory;
    _tempAvailableOnly = widget.currentAvailableOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Title Block
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Search Filters',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            // Filter Item 1: Dropdown Category Selection
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Category:', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _tempCategory,
                    items: <String>['All', 'Electronics', 'Clothing', 'Books']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                    onChanged: (newValue) {
                      setState(() => _tempCategory = newValue!);
                    },
                  ),
                ],
              ),
            ),

            // Filter Item 2: Switch for Availability
            SwitchListTile(
              title: const Text(
                'In Stock Only',
                style: TextStyle(fontSize: 16),
              ),
              value: _tempAvailableOnly,
              onChanged: (bool value) {
                setState(() => _tempAvailableOnly = value);
              },
            ),

            const Spacer(), // Pushes buttons to the bottom
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(
                        context,
                      ), // Just closes drawer, discards changes
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. Pass data back to parent screen
                        widget.onApplyFilters(
                          _tempCategory,
                          _tempAvailableOnly,
                        );
                        // 2. Close drawer
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
