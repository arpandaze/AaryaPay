part of 'home_favorites_bloc.dart';

class HomeFavoritesState extends Equatable {
  final List<Favorite>? favouritesList;
  final bool isLoaded;
  final Map? particularUser;
  final String? displayAmount;

  const HomeFavoritesState({
    this.favouritesList,
    this.isLoaded = false,
    this.particularUser,
    this.displayAmount,

  });

  HomeFavoritesState copyWith({
    List<Favorite>? favouritesList,
    bool? isLoaded,
    Map? particularUser,
    String? displayAmount,

  }) {
    return HomeFavoritesState(
      favouritesList: favouritesList ?? this.favouritesList,
      isLoaded: isLoaded ?? this.isLoaded,
      particularUser: particularUser ?? this.particularUser,
      displayAmount: displayAmount ?? this.displayAmount,

    );
  }

  @override
  List<Object?> get props => [
        favouritesList,
        isLoaded,
        particularUser,
        displayAmount,

      ];
}
