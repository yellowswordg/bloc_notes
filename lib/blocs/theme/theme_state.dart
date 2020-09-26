part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;

  ThemeState({@required this.themeData});

  @override
  // TODO: implement props
  List<Object> get props => [themeData];

  @override
  String toString() {
    return 'ThemeState { themeData: $themeData } ';
  }
}
