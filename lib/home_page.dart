import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items/bloc/items_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  void _showItemDialog(BuildContext context, int? id, String existingName) {
    final TextEditingController controller =
        TextEditingController(text: existingName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Item' : 'Update Item'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter item name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final itemName = controller.text;
                if (id == null) {
                  context.read<ItemsBloc>().add(AddItem(itemName));
                } else {
                  context.read<ItemsBloc>().add(UpdateItem(id, itemName));
                }
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController keywordController = TextEditingController();

  void _searchItems(BuildContext context) {
    final searchTerm = keywordController.text;
    context.read<ItemsBloc>().add(SearchItem(searchTerm));
  }

  @override
  Widget build(BuildContext context) {
    context.read<ItemsBloc>().add(LoadItems());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CRUD with Bloc'),
      ),
      body: BlocBuilder<ItemsBloc, ItemsState>(
        builder: (context, state) {
          if (state is ItemLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemLoadSuccess) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    controller: keywordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      hintText: 'Search items',
                      suffixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (_) {
                      _searchItems(context);
                    },
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['name']),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showItemDialog(
                                        context, item['id'], item['name']);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    context
                                        .read<ItemsBloc>()
                                        .add(DeleteItem(item['id']));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else if (state is ItemOperationFailure) {
            return const Center(child: Text('Failed to load items'));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showItemDialog(context, null, '');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
