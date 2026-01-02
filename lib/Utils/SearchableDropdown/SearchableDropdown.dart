import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownWithSearch extends StatelessWidget {
  final String hintText;
  final List<Map<String, dynamic>> items;
  final RxInt selectedId;
  final Function(Map<String, dynamic>) onSelect;

  const DropdownWithSearch({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedItem =
      items.firstWhereOrNull((e) => e['id'] == selectedId.value);

      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openBottomSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              const Icon(Icons.admin_panel_settings,
                  color: Colors.deepPurple),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedItem?['email'] ?? hintText,
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedItem == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 28),
            ],
          ),
        ),
      );
    });
  }

  /// 🔥 Attractive searchable bottom sheet
  void _openBottomSheet(BuildContext context) {
    final RxString searchText = ''.obs;

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            /// Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            /// Title
            const Text(
              "Select Admin",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// Search box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by email",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) =>
                searchText.value = value.toLowerCase(),
              ),
            ),

            const SizedBox(height: 12),

            /// Admin list
            Expanded(
              child: Obx(() {
                final filtered = items.where((e) {
                  return e['email']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.value);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text("No admin found"),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: Colors.grey.shade300),
                  itemBuilder: (_, index) {
                    final admin = filtered[index];
                    final isSelected =
                        admin['id'] == selectedId.value;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          admin['email'][0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(admin['email']),
                      subtitle: Text(admin['role']),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                          color: Colors.green)
                          : null,
                      onTap: () {
                        onSelect(admin);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
