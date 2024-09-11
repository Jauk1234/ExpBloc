import 'package:exp/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:uuid/uuid.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> categoriesIcon = [
    'entertainment',
    'food',
    'home',
    'pet',
    'shopping',
    'tech',
    'travel',
  ];
  return showDialog(
      context: context,
      builder: (ctx) {
        String iconSelected = '';
        Color colorSelected = Colors.white;
        TextEditingController categoryNameController = TextEditingController();
        TextEditingController categoryIconController = TextEditingController();
        TextEditingController categoryColorController = TextEditingController();
        bool isExpended = false;
        bool isLoading = false;
        Category category = Category.empty;

        return BlocProvider.value(
          value: context.read<CreateCategoryBloc>(),
          child: BlocListener<CreateCategoryBloc, CreateCategoryState>(
            listener: (context, state) {
              if (state is CreateCategorySuccess) {
                Navigator.pop(ctx, category);
              } else if (state is CreateCategoryLoading) {
                isLoading = true;
              }
            },
            child: StatefulBuilder(
              builder: (ctx, setState) {
                return AlertDialog(
                  title: const Text('Create a Category'),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: categoryNameController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: categoryIconController,
                          onTap: () {
                            setState(() {
                              isExpended = !isExpended;
                            });
                          },
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            suffixIcon: const Icon(
                              CupertinoIcons.chevron_down,
                              size: 14,
                            ),
                            fillColor: Colors.white,
                            hintText: 'Icon',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: isExpended
                                  ? const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    )
                                  : BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        isExpended
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                      ),
                                      itemCount: categoriesIcon.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              iconSelected =
                                                  categoriesIcon[index];
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 3,
                                                color: iconSelected ==
                                                        categoriesIcon[index]
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/${categoriesIcon[index]}.png')),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: categoryColorController,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx2) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ColorPicker(
                                          pickerColor: Colors.blue,
                                          onColorChanged: (value) {
                                            setState(() {
                                              colorSelected = value;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 40,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(ctx2);
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              'Save Color',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: colorSelected,
                            hintText: 'Color',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: kToolbarHeight,
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : TextButton(
                                  onPressed: () {
                                    //create category object and POP

                                    category.categoryId = const Uuid().v1();
                                    category.name = categoryNameController.text;
                                    category.icon = iconSelected;
                                    category.color = colorSelected.value;
                                    context
                                        .read<CreateCategoryBloc>()
                                        .add(CreateCategory(category));
                                    // Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      });
}
