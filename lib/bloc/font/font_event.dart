part of 'font_bloc.dart';

abstract class FontEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FontChangeRequested extends FontEvent {
  final double resize;

  FontChangeRequested({required this.resize});
}
