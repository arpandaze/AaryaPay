part of 'home_favorites_bloc.dart';

abstract class HomeFavoritesEvent extends Equatable {
  const HomeFavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesLoadEvent extends HomeFavoritesEvent {}

class ClearEvent extends HomeFavoritesEvent {}

class LoadParticularUser extends HomeFavoritesEvent {
  final String uuid;

  LoadParticularUser({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}
