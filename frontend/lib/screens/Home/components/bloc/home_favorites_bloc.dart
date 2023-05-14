import 'package:aaryapay/repository/favourites.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'home_favorites_event.dart';
part 'home_favorites_state.dart';

class HomeFavoritesBloc extends Bloc<HomeFavoritesEvent, HomeFavoritesState> {
  final FavouritesRepository favouritesRepository;
  static const storage = FlutterSecureStorage();
  HomeFavoritesBloc({required this.favouritesRepository})
      : super(const HomeFavoritesState()) {
    on<FavoritesLoadEvent>(_onFavoritesLoad);
    on<LoadParticularUser>(_onLoadParticularUser);
    on<ClearEvent>(_onClearEvent);
    add(FavoritesLoadEvent());
  }

  void _onFavoritesLoad(
      FavoritesLoadEvent event, Emitter<HomeFavoritesState> emit) async {
    try {
      final response = await favouritesRepository.getFavourites();

      var displayAmount = await storage.read(key: "amount");
      emit(state.copyWith(
          favouritesList: response['data'],
          isLoaded: true,
          displayAmount: displayAmount));
    } catch (e) {
      emit(state.copyWith(isLoaded: false));
      print(e.toString());
    }
  }

  void _onClearEvent(ClearEvent event, Emitter<HomeFavoritesState> emit) {
    emit(state.copyWith(particularUser: null));
  }

  void _onLoadParticularUser(
      LoadParticularUser event, Emitter<HomeFavoritesState> emit) async {
    try {
      var response =
          await favouritesRepository.getParticularUser(uuid: event.uuid);
      var displayAmount = await storage.read(key: "amount");

      emit(state.copyWith(
          particularUser: response["data"], displayAmount: displayAmount));
    } catch (e) {
      print(e.toString());
    }
  }
}
