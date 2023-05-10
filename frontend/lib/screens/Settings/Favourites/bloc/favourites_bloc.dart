import 'package:aaryapay/constants.dart';
import 'package:aaryapay/repository/favourites.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final FavouritesRepository favouritesRepository;

  FavouritesBloc({required this.favouritesRepository})
      : super(const FavouritesState()) {
    on<AddButtonClicked>(_onAddButtonClicked);
    on<FavouritesLoadEvent>(_onFavouritesLoad);
    on<FavouritesFieldChanged>(_onFavouritesFieldChanged);
    on<RemoveEvent>(_onRemoveEvent);
    add(FavouritesLoadEvent());
  }

  void _onFavouritesFieldChanged(
      FavouritesFieldChanged event, Emitter<FavouritesState> emit) async {
    emit(state.copyWith(email: event.email, msgType: MessageType.idle));
  }

  void _onAddButtonClicked(
      AddButtonClicked event, Emitter<FavouritesState> emit) async {
    try {
      final response =
          await favouritesRepository.postFavorites(email: state.email!);
      if (response['status'] == 201) {
        emit(state.copyWith(
            msgType: MessageType.success, errorText: "Added Successfully"));
        add(FavouritesLoadEvent());
      }
    } catch (e) {
      emit(state.copyWith(msgType: MessageType.error, errorText: e.toString()));
    }
  }

  void _onRemoveEvent(RemoveEvent event, Emitter<FavouritesState> emit) async {
    try {
      final response =
          await favouritesRepository.deleteFavorites(email: event.email!);

      if (response["status"] == 202) {
        emit(state.copyWith(
            msgType: MessageType.success, errorText: "Removed Successfully"));
        add(FavouritesLoadEvent());
      }
    } catch (e) {
      emit(state.copyWith(
          msgType: MessageType.error, errorText: "Error removing favorites"));
    }
  }

  void _onFavouritesLoad(
      FavouritesLoadEvent event, Emitter<FavouritesState> emit) async {
    final response = await favouritesRepository.getFavourites();
    if (response["data"] != null) {
      emit(state.copyWith(isLoaded: true, favouritesList: response['data']));
    } else {
      emit(state.copyWith(isLoaded: false));
    }
  }
}
