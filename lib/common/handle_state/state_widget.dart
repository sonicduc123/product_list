import 'package:flutter/material.dart';
import 'view_state.dart';

class StateWidget<T> extends StatelessWidget {
  const StateWidget({
    super.key,
    required this.state,
    required this.successBuilder,
    this.errorBuilder,
    this.emptyWidget,
    this.loadingWidget,
  });

  final ViewState<T> state;
  final Widget Function(T data) successBuilder;
  final Widget Function(Exception e)? errorBuilder;
  final Widget? emptyWidget;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case LoadingState _:
        return loadingWidget ?? const Center(child: CircularProgressIndicator());
      case SuccessState _:
        final successState = state as SuccessState<T>;
        return successBuilder.call(successState.value); // Replace with your success widget
      case EmptyState _:
        return emptyWidget ?? const Center(child: Text('No data available'));
      case FailureState _:
        final failureState = state as FailureState<T>;
        return errorBuilder?.call(failureState.value) ?? Center(child: Text('${failureState.value}'));
      default:
        return const SizedBox();
    }
  }
}
