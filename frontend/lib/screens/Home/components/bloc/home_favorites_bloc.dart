import 'package:aaryapay/global/caching/favorite.dart';
import 'package:aaryapay/repository/favourites.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'home_favorites_event.dart';
part 'home_favorites_state.dart';

class HomeFavoritesBloc extends Bloc<HomeFavoritesEvent, HomeFavoritesState> {
  static const storage = FlutterSecureStorage();
  HomeFavoritesBloc()
      : super(const HomeFavoritesState()) {
    on<LoadParticularUser>(_onLoadParticularUser);
    on<ClearEvent>(_onClearEvent);
    add(ClearEvent());
  }

  
  void _onClearEvent(ClearEvent event, Emitter<HomeFavoritesState> emit) {
    emit(state.copyWith(clear: !state.clear));
  }

  void _onLoadParticularUser(
      LoadParticularUser event, Emitter<HomeFavoritesState> emit) async {
    try {
      var particularUser = event.favorites
          .where((element) => element.id.toString() == event.uuid)
          .toList();
      emit(state.copyWith(particularUser: particularUser[0].toJson()));
    } catch (e) {
      print(e.toString());
    }
  }
}
