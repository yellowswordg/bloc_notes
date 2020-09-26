part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}
//we going to call LoadTheme when the user first time loading the app 
class LoadTheme extends ThemeEvent {}
//when user taps the icon to change the theme
class UpdateTheme extends ThemeEvent {}
