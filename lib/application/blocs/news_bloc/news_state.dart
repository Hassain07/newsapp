part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsLoadingState extends NewsState {}
class NewsEmptyState extends NewsState {}

class NewsLoadedState extends NewsState {
  final NewsModel data;

  NewsLoadedState(this.data);
}
