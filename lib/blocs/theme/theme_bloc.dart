import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_notes/config/constants.dart';
import 'package:bloc_notes/config/themes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  // TODO: implement initialState
  ThemeState get initialState =>
      ThemeState(themeData: Themes.themeData[AppTheme.LightTheme]);
  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (event is LoadTheme) {
      yield* _mapLoadThemeToState(prefs);
    } else if (event is UpdateTheme) {
      yield* _mapUpdateThemeToState(prefs);
    }
  }

  Stream<ThemeState> _mapLoadThemeToState(SharedPreferences prefs) async* {
    yield* _mapSetTheme(
        prefs, prefs.getBool(Constants.sharedPrefIsDarkMode) ?? false);
  }

  Stream<ThemeState> _mapUpdateThemeToState(SharedPreferences prefs) async* {
    yield* _mapSetTheme(
        prefs, !prefs.getBool(Constants.sharedPrefIsDarkMode) ?? false);
  }

  Stream<ThemeState> _mapSetTheme(
      SharedPreferences prefs, bool isDarkMode) async* {
    //reason we use isDarkMode constants is to save us from typing and typos
    prefs.setBool(Constants.sharedPrefIsDarkMode, isDarkMode);
    yield ThemeState(
        themeData: Themes
            .themeData[isDarkMode ? AppTheme.DarkTheme : AppTheme.LightTheme]);
  }
}
