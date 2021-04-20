import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newsapp/domain/models/news_api_model.dart';
import 'package:newsapp/infrastructure/repository/news_repo.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepo repo;
  NewsBloc(this.repo) : super(NewsLoadingState());

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is GetNewsEvent) {
      yield NewsLoadingState();
      final data = await repo.getData();
      if (data != null)
        yield NewsLoadedState(data);
      else
        yield NewsEmptyState();
    }
  }
}
