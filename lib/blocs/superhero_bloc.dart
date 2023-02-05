import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superhero_storage.dart';

import '../model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  final String id;

  final superheroSubject = BehaviorSubject<Superhero>();
  final superheroPageStateSubject = BehaviorSubject<SuperheroPageState>();

  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? requestSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  SuperheroBloc({
    this.client,
    required this.id,
  }) {
    getFromFavorites();
  }

  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription = FavoriteSuperheroStorage.getInstance()
        .getSuperhero(id)
        .asStream()
        .listen((superhero) {
          if (superhero != null) {
            superheroSubject.add(superhero);
            superheroPageStateSubject.add(SuperheroPageState.loaded);
          } else {
            superheroPageStateSubject.add(SuperheroPageState.loading);
          }
      requestSuperhero(superhero != null);
    }, onError: (error, stackTrace) {
      print('Error happened in getFromFavorites: $error, $stackTrace');
    });
  }

  void addToFavorite() {
    final superhero = superheroSubject.valueOrNull;
    if (superhero == null) {
      print("Error: superhero is null while shouldn't be");
      return;
    }
    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperheroStorage.getInstance()
        .addToFavorites(superhero)
        .asStream()
        .listen((event) {
      print('Added to favorites $event');
    }, onError: (error, stackTrace) {
      print('Error happened in addToFavorite: $error, $stackTrace');
    });
  }

  void removeFromFavorites() {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperheroStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen((event) {
      print('Removed from favorites $event');
    }, onError: (error, stackTrace) {
      print('Error happened in removeFromFavorites: $error, $stackTrace');
    });
  }

  Stream<bool> observeIsFavorite() {
    return FavoriteSuperheroStorage.getInstance().observeIsFavorite(id);
  }

  void requestSuperhero(final bool isInFavorites) {
    requestSubscription?.cancel();
    requestSubscription = request().asStream().listen((superhero) {
      superheroSubject.add(superhero);
      superheroPageStateSubject.add(SuperheroPageState.loaded);
    }, onError: (error, stackTrace) {
      if (!isInFavorites) {
        superheroPageStateSubject.add(SuperheroPageState.error);
      }
      print('Error happened in requestSuperhero: $error, $stackTrace');
    });
  }
  void retry() {
    superheroPageStateSubject.add(SuperheroPageState.loading);
    requestSuperhero(false);
  }

  Future<Superhero> request() async {
    final token = dotenv.env["SUPERHERO_TOKEN"];

    final response = await (client ??= http.Client())
        .get(Uri.parse("https://superheroapi.com/api/$token/$id"));

    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException('Server error happened');
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException('Client error happened');
    }
    final decoded = json.decode(response.body);
    if (decoded['response'] == 'success') {
      final superhero = Superhero.fromJson(decoded);
      await FavoriteSuperheroStorage.getInstance().updateIfInFavorites(superhero);
      return superhero;
    } else if (decoded['response'] == 'error') {
      throw ApiException('Client error happened');
    }
    throw Exception('Unknown error happened');
  }

  Stream<Superhero> observeSuperhero() => superheroSubject.distinct();
  Stream<SuperheroPageState> observeSuperheroPageState() => superheroPageStateSubject.distinct();

  void dispose() {
    client?.close();
    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
    getFromFavoritesSubscription?.cancel();
    superheroSubject.close();
    superheroPageStateSubject.close();
  }
}
enum SuperheroPageState {loading, loaded, error}