import 'package:thefilms/model/details_model.dart';
import 'package:thefilms/model/preview_model.dart';
import 'package:thefilms/secret/themoviedb_api.dart' as secret;
import 'package:thefilms/utils/constants.dart';
import 'package:thefilms/utils/file_manager.dart';
import 'package:thefilms/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'networking.dart';


enum TvPageType {
  airing_today,
  popular,
  on_the_air,
  top_rated,
}

class TvService {
  Future _getData({required String url}) async {
    NetworkHelper networkHelper = NetworkHelper(Uri.parse(url));
    var data = await networkHelper.getData();
    return data;
  }

  Future<List<TheFilmCard>> getTv({
    required TvPageType tvType,
    required Color themeColor,
  }) async {
    List<TheFilmCard> temp = [];
    String mTypString =
        tvType.toString().substring(11, tvType.toString().length);

    var data = await _getData(
      url: '$kThetvdbURL/$mTypString?api_key=${secret.themoviedbApi}&language=en-US&page=1',
    );

    print('$kThetvdbURL/$mTypString?api_key=${secret.themoviedbApi}');

    for (var item in data["results"]) {
      temp.add(
        TheFilmCard(
          previewModels: PreviewModels(
            isFavorite:
                await isMovieInFavorites(movieID: item["id"].toString()),
            year: (item["first_air_date"].toString().length > 4)
                ? item["first_air_date"].toString().substring(0, 4)
                : "",
            imageUrl: "$kThemoviedbImageURL${item["poster_path"]}",
            title: item["name"],
            id: item["id"].toString(),
            rating: item["vote_average"].toDouble(),
            overview: item["overview"],
          ),
          themeColor: themeColor,
        ),
      );
    }
    return Future.value(temp);
  }

  Future<List<TheFilmCard>> searchMovies({
    required String movieName,
    required Color themeColor,
  }) async {
    List<TheFilmCard> temp = [];

    var data = await _getData(
      url:
          '$kThemoviedbSearchURL/?api_key=${secret.themoviedbApi}&language=en-US&page=1&include_adult=false&query=$movieName',
    );

    for (var item in data["results"]) {
      try {
        temp.add(
          TheFilmCard(
            previewModels: PreviewModels(
              isFavorite:
                  await isMovieInFavorites(movieID: item["id"].toString()),
              year: (item["first_air_date"].toString().length > 4)
                  ? item["first_air_date"].toString().substring(0, 4)
                  : "",
              imageUrl: "https://image.tmdb.org/t/p/w500${item["poster_path"]}",
              title: item["name"],
              id: item["id"].toString(),
              rating: item["vote_average"].toDouble(),
              overview: item["overview"],
            ),
            themeColor: themeColor,
          ),
        );
      } catch (e, s) {
        print(s);
        print(item["first_air_date"]);
      }
    }
    return Future.value(temp);
  }

  Future<DetailModels> getTvDetails({required String tvID}) async {
    var data = await _getData(
      url:
          '$kThetvdbURL/$tvID?api_key=${secret.themoviedbApi}&language=en-US',
    );

    List<String> temp = [];
    for (var item in data["genres"]) {
      temp.add(item["name"]);
    }

    return Future.value(
      DetailModels(
        backgroundURL:
            "https://image.tmdb.org/t/p/w500${data["backdrop_path"]}",
        title: data["name"],
        year: (data["first_air_date"].toString().length > 4)
            ? data["first_air_date"].toString().substring(0, 4)
            : "",
        isFavorite: await isMovieInFavorites(movieID: data["id"].toString()),
        rating: data["vote_average"].toDouble(),
        genres: temp,
        overview: data["overview"],
      ),
    );
  }

  Future<List<TheFilmCard>> getFavorites(
      {required Color themeColor, required int bottomBarIndex}) async {
    List<TheFilmCard> temp = [];
    List<String> favoritesID = await getFavoritesID();
    for (var item in favoritesID) {
      if (item != "") {
        var data = await _getData(
          url:
              '$kThetvdbURL/$item?api_key=${secret.themoviedbApi}&language=en-US',
        );

        temp.add(
          TheFilmCard(
            contentLoadedFromPage: bottomBarIndex,
            themeColor: themeColor,
            previewModels: PreviewModels(
              isFavorite:
                  await isMovieInFavorites(movieID: data["id"].toString()),
              year: (data["first_air_date"].toString().length > 4)
                  ? data["first_air_date"].toString().substring(0, 4)
                  : "",
              imageUrl: "https://image.tmdb.org/t/p/w500${data["poster_path"]}",
              title: data["name"],
              id: data["id"].toString(),
              rating: data["vote_average"].toDouble(),
              overview: data["overview"],
            ),
          ),
        );
      }
    }
    return temp;
  }
}
