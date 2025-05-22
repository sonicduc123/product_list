import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../widgets/display_info_text.dart';
import '../model/product_model.dart';

class ProductListItem extends StatefulWidget {
  const ProductListItem({super.key, required this.data, this.onBookmark});

  final ProductModel data;
  final VoidCallback? onBookmark;

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.marginComponent),
      child: InkWell(
        onTap: () {

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.marginText),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: widget.data.thumbnail ?? '',
                placeholder: (context, url) => CircleAvatar(
                  radius: 25,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  backgroundImage: imageProvider,
                ),
              ),
              SizedBox(width: Space.marginComponent),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data.title ?? '', style: TextStyle(fontSize: 15),),
                    const SizedBox(height: Space.marginText),
                    DisplayInfoText(
                      title: "Price",
                      value: NumberFormat.simpleCurrency().format(widget.data.price),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.data.isFavorite == true ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  widget.onBookmark?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
