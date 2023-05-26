part of 'home_favorites_bloc.dart';

abstract class HomeFavoritesEvent extends Equatable {
  const HomeFavoritesEvent();

  @override
  List<Object?> get props => [];
}

class HomeFavoritesLoadEvent extends HomeFavoritesEvent {
  final List<Favorite> favorites;
  final double amount;

  HomeFavoritesLoadEvent({required this.favorites, required this.amount});

  @override
  List<Object?> get props => [favorites];
}

class ClearEvent extends HomeFavoritesEvent {}

class LoadParticularUser extends HomeFavoritesEvent {
  final String uuid;
  final List<Favorite> favorites;

  LoadParticularUser({required this.uuid, required this.favorites});

  @override
  List<Object?> get props => [uuid];
}
