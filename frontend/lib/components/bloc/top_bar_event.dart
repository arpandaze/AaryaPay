part of 'top_bar_bloc.dart';

abstract class TopBarEvent extends Equatable {
  const TopBarEvent();

  @override
  List<Object> get props => [];
}

class GetInformation extends TopBarEvent {}

class EyeTapped extends TopBarEvent {
  final bool tapped;

  EyeTapped({this.tapped = false});

  @override
  List<Object> get props => [tapped];
}
