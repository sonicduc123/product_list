sealed class ViewState<T> {}

class InitialState<T> extends ViewState<T> {}

class LoadingState<T> extends ViewState<T> {}

class EmptyState<T> extends ViewState<T> {}

class SuccessState<T> extends ViewState<T> {
  final T value;

  SuccessState(this.value);
}

class FailureState<T> extends ViewState<T> {
  final Exception value;

  FailureState(this.value);
}