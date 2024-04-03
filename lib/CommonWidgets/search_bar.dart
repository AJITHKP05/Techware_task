import 'package:flutter/material.dart';

import 'qr_view.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function() onChanged;
  const SearchBarWidget({super.key, required this.searchController, required this.onChanged});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SearchBar(
        controller: widget.searchController,
        padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0)),
        onChanged: (_) {
           widget.onChanged();
        },
        leading: const Icon(Icons.search),
        trailing: <Widget>[
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QRScanner(
                  onDetect: (p0) {
                    widget.searchController.text = p0 ?? "";
                     widget.onChanged();
                  },
                ),
              ));
            },
          )
        ]);
  }
}
