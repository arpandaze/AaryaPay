part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class LoadDataEvent extends DataEvent {}

class RequestSyncEvent extends DataEvent {}

class SubmitTAMEvent extends DataEvent {
  final TransactionAuthorizationMessage tam;

  const SubmitTAMEvent(this.tam);

  @override
  List<Object> get props => [tam];
}

class SubmitTVCEvent extends DataEvent {
  final TransactionVerificationCertificate tvc;

  const SubmitTVCEvent(this.tvc);

  @override
  List<Object> get props => [tvc];
}

class UpdateServerKeyEvent extends DataEvent {}

class UserAuthenticatedEvent extends DataEvent {
  final String sessionToken;
  final bool isPrimary;

  const UserAuthenticatedEvent(this.sessionToken, this.isPrimary);

  @override
  List<Object> get props => [sessionToken, isPrimary];
}
