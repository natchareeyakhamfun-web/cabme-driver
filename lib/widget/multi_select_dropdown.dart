import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/round_button_fill.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MultiSelectDropdown<T> extends StatelessWidget {
  final List<T> items;
  final RxList<T> selectedItems;
  final List<T>? initialSelectedItems;
  final String hintText;
  final String dialogTitle;
  final String Function(T) labelSelector;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.initialSelectedItems,
    required this.hintText,
    required this.labelSelector,
    required this.dialogTitle,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    if (selectedItems.isEmpty && initialSelectedItems != null && initialSelectedItems!.isNotEmpty) {
      selectedItems.addAll(initialSelectedItems!);
    }

    return Obx(() => InkWell(
          onTap: () => _showMultiSelectDialog(themeChange,context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedItems.isEmpty ? hintText : selectedItems.map(labelSelector).join(', '),
                    style: TextStyle(
                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                      fontFamily: AppThemeData.medium,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                )
              ],
            ),
          ),
        ));
  }

  void _showMultiSelectDialog(themeChange,BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            dialogTitle.tr,
            style: AppThemeData.boldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.primaryDefault : AppThemeData.primaryDefault,),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: items.map((item) {
                return Obx(() => CheckboxListTile(
                      value: selectedItems.contains(item),
                      title: Text(
                        labelSelector(item),
                        style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,),
                      ),
                      onChanged: (bool? selected) {
                        if (selected == true) {
                          selectedItems.add(item);
                        } else {
                          selectedItems.remove(item);
                        }
                      },
                    ));
              }).toList(),
            ),
          ),
          actions: [
            RoundedButtonFill(
              title: "Save".tr,
              height: 5.5,
              color: AppThemeData.primaryDefault,
              textColor: AppThemeData.neutral50,
              onPress: () async {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
