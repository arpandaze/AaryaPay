import 'package:aaryapay/repository/favourites.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesModal {
  final AssetImage? imageSrc;
  final String? name;
  final String? userTag;
  final String? dateAdded;

  FavouritesModal(
      {this.imageSrc = const AssetImage("assets/images/default-pfp.png"),
      this.name,
      this.userTag,
      this.dateAdded});
}

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final FavouritesRepository favouritesRepository;

  FavouritesBloc({required this.favouritesRepository})
      : super(const FavouritesState()) {
    on<AddButtonClicked>(_onAddButtonClicked);
    on<FavouritesLoadEvent>(_onFavouritesLoad);
  }

  void _onAddButtonClicked(
      AddButtonClicked event, Emitter<FavouritesState> emit) async {}

  void _onFavouritesLoad(
      FavouritesLoadEvent event, Emitter<FavouritesState> emit) async {
    final response = await favouritesRepository.getFavourites();

    print(response['data']);
    emit(state.copyWith(favouritesList: response['data'], isLoaded: true));
    print("STATE");
  }
}
