import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownWithSearch extends StatefulWidget {
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
  State<DropdownWithSearch> createState() => _DropdownWithSearchState();
}

class _DropdownWithSearchState extends State<DropdownWithSearch> {
  RxBool isOpen = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  RxList<Map<String, dynamic>> filteredItems = <Map<String, dynamic>>[].obs;
  String? selectedText;

  @override
  void initState() {
    super.initState();
    filteredItems.assignAll(widget.items);
    selectedText = null;
    searchCtrl.addListener(() {
      final query = searchCtrl.text.toLowerCase();
      filteredItems.value = widget.items
          .where((e) => e['email'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void toggleDropdown() {
    isOpen.value = !isOpen.value;
    if (!isOpen.value) {
      searchCtrl.clear();
      filteredItems.assignAll(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedText ?? widget.hintText,
                  style: TextStyle(
                    color: selectedText == null ? Colors.grey.shade600 : Colors.black,
                  ),
                ),
                Icon(
                  isOpen.value ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        if (isOpen.value)
          Container(
            height: 200,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchCtrl,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                Expanded(
                  child: filteredItems.isEmpty
                      ? const Center(child: Text("No items found"))
                      : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ListTile(
                        title: Text(item['email']),
                        onTap: () {
                          selectedText = item['email'];
                          widget.selectedId.value = item['id'];
                          widget.onSelect(item);
                          toggleDropdown();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    ));
  }
}
