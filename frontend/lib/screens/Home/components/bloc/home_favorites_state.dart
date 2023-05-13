part of 'home_favorites_bloc.dart';

class HomeFavoritesState extends Equatable {
  final List<dynamic>? favouritesList;
  final bool isLoaded;
  final Map? particularUser;

  const HomeFavoritesState({
    this.favouritesList,
    this.isLoaded = false,
    this.particularUser,
  });

  HomeFavoritesState copyWith(
      {List<dynamic>? favouritesList, bool? isLoaded, Map? particularUser}) {
    return HomeFavoritesState(
      favouritesList: favouritesList ?? this.favouritesList,
      isLoaded: isLoaded ?? this.isLoaded,
      particularUser: particularUser ?? this.particularUser,
    );
  }

  @override
  List<Object?> get props => [
        favouritesList,
        isLoaded,
        particularUser,
      ];
}
