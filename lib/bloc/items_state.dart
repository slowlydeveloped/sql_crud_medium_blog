part of 'items_bloc.dart';

sealed class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

final class ItemsInitial extends ItemsState {}

class ItemLoadInProgress extends ItemsState {}

class ItemLoadSuccess extends ItemsState {
  final List<Map<String, dynamic>> items;

  const ItemLoadSuccess(this.items);
}

class ItemOperationFailure extends ItemsState {
  final String message;

  const ItemOperationFailure(this.message);
}
