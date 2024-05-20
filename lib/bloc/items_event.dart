part of 'items_bloc.dart';

sealed class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadItems extends ItemsEvent {}

class AddItem extends ItemsEvent {
  final String name;

  const AddItem(this.name);
}

class UpdateItem extends ItemsEvent {
  final int id;
  final String name;

  const UpdateItem(this.id, this.name);
}

class DeleteItem extends ItemsEvent {
  final int id;

  const DeleteItem(this.id);
}

class SearchItem extends ItemsEvent {
  final String keyword;
  const SearchItem(this.keyword);
}
