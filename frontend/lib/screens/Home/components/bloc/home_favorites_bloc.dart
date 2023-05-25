import 'package:aaryapay/global/caching/favorite.dart';
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
    on<HomeFavoritesLoadEvent>(_onFavoritesLoad);
    on<LoadParticularUser>(_onLoadParticularUser);
    on<ClearEvent>(_onClearEvent);
  }

  void _onFavoritesLoad(
      HomeFavoritesLoadEvent event, Emitter<HomeFavoritesState> emit) async {
    try {
      emit(state.copyWith(
          favouritesList: event.favorites,
          isLoaded: true,
          displayAmount: event.amount.toString()));
    } catch (e) {
      emit(state.copyWith(isLoaded: false));
    }
  }

  void _onClearEvent(ClearEvent event, Emitter<HomeFavoritesState> emit) {
    emit(state.copyWith(particularUser: null));
  }

  void _onLoadParticularUser(
      LoadParticularUser event, Emitter<HomeFavoritesState> emit) async {
    try {
      var particularUser = event.favorites.where((element) => element.id.toString() == event.uuid).toList();
      emit(state.copyWith(particularUser: particularUser[0].toJson()));
          } catch (e) {
      print(e.toString());
    }
  }

  }
