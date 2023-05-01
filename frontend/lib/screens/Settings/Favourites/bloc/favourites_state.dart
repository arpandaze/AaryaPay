part of 'favourites_bloc.dart';

class FavouritesState extends Equatable {
  final String? email;
  final List<dynamic>? favouritesList;
  final bool isLoaded;
  const FavouritesState(
      {this.favouritesList, this.email, this.isLoaded = false});

  FavouritesState copyWith({
    String? email,
    List<dynamic>? favouritesList,
    bool isLoaded = false,
  }) {
    return FavouritesState(
      email: email ?? this.email,
      favouritesList: favouritesList ?? this.favouritesList,
      isLoaded: isLoaded,
    );
  }

  @override
  List<Object?> get props => [
        email,
        favouritesList,
        isLoaded,
      ];
}
