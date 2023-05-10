part of 'favourites_bloc.dart';

class FavouritesState extends Equatable {
  final String? email;
  final List<dynamic>? favouritesList;
  final bool isLoaded;
  final MessageType msgType;
  final String errorText;

  const FavouritesState({
    this.favouritesList,
    this.email,
    this.isLoaded = false,
    this.msgType = MessageType.idle,
    this.errorText = "",
  });

  FavouritesState copyWith({
    String? email,
    List<dynamic>? favouritesList,
    bool? isLoaded,
    MessageType? msgType,
    String? errorText,
  }) {
    return FavouritesState(
      email: email ?? this.email,
      favouritesList: favouritesList ?? this.favouritesList,
      isLoaded: isLoaded ?? this.isLoaded,
      msgType: msgType ?? this.msgType,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object?> get props => [
        email,
        favouritesList,
        isLoaded,
        msgType,
        errorText,
      ];
}
