

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDataSource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.movieDBKey,
        'language': 'es-MX'
      }));
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response =
        await dio.get('/movie/$movieId/credits');
    if(response.statusCode != 200) throw Exception('Movie with id: $movieId not found');
    final castResponse = CreditsResponse.fromJson(response.data);
    final List<Actor> actors = castResponse.cast.map((cast) => ActorMapper.castToEntity(cast)).toList();
    return actors;
  }


}