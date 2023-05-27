import 'package:aaryapay/helper/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'top_bar_event.dart';
part 'top_bar_state.dart';

class TopBarBloc extends Bloc<TopBarEvent, TopBarState> {
  static const storage = FlutterSecureStorage();
  TopBarBloc() : super(TopBarState()) {
    on<GetInformation>(_onGetInfo);
    on<EyeTapped>(_onEyeTapped);
    add(GetInformation());
  }

  void _onGetInfo(GetInformation event, Emitter<TopBarState> emit) async {
    var amount = (await storage.read(key: "available_balance"));
    var uuid = (await storage.read(key: "user_id"));
    emit(state.copyWith(
      amount: amount,
      uuid: uuid,
    ));
  }

  void _onEyeTapped(EyeTapped event, Emitter<TopBarState> emit) async {
    emit(state.copyWith(hide: event.tapped));
  }

}
