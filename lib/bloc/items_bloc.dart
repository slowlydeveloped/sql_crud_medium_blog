//Dependencies
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

//Paths
import '../my_sqlite.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final DatabaseHelper databaseHelper;
  ItemsBloc(this.databaseHelper) : super(ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
    on<AddItem>(_onAddItem);
    on<UpdateItem>(_onUpdateItem);
    on<DeleteItem>(_onDeleteItem);
    on<SearchItem>(_onSearchItem);
  }
  
  void _onLoadItems(LoadItems event, Emitter<ItemsState> emit) async {
    emit(ItemLoadInProgress());
    try {
      final items = await databaseHelper.fetchItems();
      emit(ItemLoadSuccess(items));
    } catch (_) {
      emit(const ItemOperationFailure(
          "Failed to fetch the items in the database"));
    }
  }

  void _onAddItem(AddItem event, Emitter<ItemsState> emit) async {
    await databaseHelper.insertItem(event.name);
    add(LoadItems());
  }

  void _onUpdateItem(UpdateItem event, Emitter<ItemsState> emit) async {
    await databaseHelper.updateItem(event.id, event.name);
    add(LoadItems());
  }

  void _onDeleteItem(DeleteItem event, Emitter<ItemsState> emit) async {
    await databaseHelper.deleteItem(event.id);
    add(LoadItems());
  }

  void _onSearchItem(SearchItem event, Emitter<ItemsState> emit) async {
    emit(ItemLoadInProgress());
    try {
      final items = await databaseHelper.searchItems(event.keyword);
      emit(ItemLoadSuccess(items));
    } catch (_) {
      emit(const ItemOperationFailure(
          "Failed to search the items in the database"));
    }
  }
}
