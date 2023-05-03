part of 'favourites_bloc.dart';

abstract class FavouritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavouritesFieldChanged extends FavouritesEvent {
  final String? email;
  FavouritesFieldChanged({this.email});

  @override
  List<Object?> get props => [email];
}

class FavouritesLoadEvent extends FavouritesEvent {}

class AddButtonClicked extends FavouritesEvent {}

class RemoveEvent extends FavouritesEvent {
  final String? email;
  RemoveEvent({this.email});

  @override
  List<Object?> get props => [email];
}
