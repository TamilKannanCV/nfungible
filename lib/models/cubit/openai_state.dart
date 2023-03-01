part of 'openai_cubit.dart';

@immutable
abstract class OpenAIState {}

class OpenAIInitial extends OpenAIState {}

class OpenAILoading extends OpenAIState {}

class OpenAIError extends OpenAIState {}

class OpenAILoaded extends OpenAIState {
  final List<String> urls;

  OpenAILoaded(this.urls);
}
