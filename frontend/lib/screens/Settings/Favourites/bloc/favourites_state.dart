part of 'favourites_bloc.dart';

class FavouritesState extends Equatable {
  final String? email;
  final List<dynamic>? favouritesList;
  final bool isLoaded;
  final MessageType msgType;
  final String errorText;
  final bool start;

  const FavouritesState({
    this.favouritesList,
    this.email,
    this.isLoaded = false,
    this.msgType = MessageType.idle,
    this.errorText = "",
    this.start = false,
  });

  FavouritesState copyWith({
    String? email,
    List<dynamic>? favouritesList,
    bool? isLoaded,
    MessageType? msgType,
    String? errorText,
    bool? start,
  }) {
    return FavouritesState(
      email: email ?? this.email,
      favouritesList: favouritesList ?? this.favouritesList,
      isLoaded: isLoaded ?? this.isLoaded,
      msgType: msgType ?? this.msgType,
      errorText: errorText ?? this.errorText,
      start: start ?? this.start,
    );
  }

  @override
  List<Object?> get props => [
        email,
        favouritesList,
        isLoaded,
        msgType,
        errorText,
        start,
      ];
}
