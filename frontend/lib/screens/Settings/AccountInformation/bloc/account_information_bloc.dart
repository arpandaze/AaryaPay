import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_information_event.dart';
part 'account_information_state.dart';

class AccountInformationBloc
    extends Bloc<AccountInformationEvent, AccountInformationState> {
  AccountInformationBloc() : super(AccountInformationState()) {
    on<AccountInformationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
