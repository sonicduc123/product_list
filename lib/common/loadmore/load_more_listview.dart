import 'package:flutter/material.dart';

class LoadMoreListview extends StatefulWidget {
  const LoadMoreListview({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onGetMoreData,
    required this.hasMore,
    this.loadMoreError,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Future<void> Function() onGetMoreData;
  final bool hasMore;
  final String? loadMoreError;

  @override
  State<LoadMoreListview> createState() => _LoadMoreListviewState();
}

class _LoadMoreListviewState extends State<LoadMoreListview> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading && widget.hasMore) {
        setState(() {
          _isLoading = true;
        });

        await widget.onGetMoreData.call();

        setState(() {
          _isLoading = false;
        });

        if (widget.loadMoreError?.isNotEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.loadMoreError ?? 'Load more error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading && !widget.hasMore) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No more data'),
            backgroundColor: Colors.grey,
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.key,
      controller: _scrollController,
      itemCount: widget.itemCount + 1,
      itemBuilder: (context, index) {
        if (index == widget.itemCount) {
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox();
        }
        return widget.itemBuilder(context, index);
      },
    );
  }
}
