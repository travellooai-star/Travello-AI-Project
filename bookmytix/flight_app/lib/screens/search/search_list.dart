import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/search_filter/city_list_autocomplete.dart';
import 'package:flight_app/widgets/search_filter/search_input.dart';
import 'package:flight_app/widgets/search_filter/search_tags.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final TextEditingController _textRef = TextEditingController();
  final GlobalKey _historyKey = GlobalKey();

  bool _showList = false;

  @override
  void initState() {
    super.initState();
    _textRef.addListener(_checkTextLength);
  }

  @override
  void dispose() {
    _textRef.dispose();
    super.dispose();
  }

  void _checkTextLength() {
    setState(() {
      _showList = _textRef.text.length >= 3;
    });
  }

  void _handleTagTap(String cityName) {
    setState(() {
      _textRef.text = cityName;
      _showList = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Get.back();
              },
            ),
            titleSpacing: 0,
            title: SearchInput(
              autofocus: true,
              textRef: _textRef,
              hintText: 'Search City or Airport',
            )),
        body: _showList
            ? CityListAutocomplete(keyword: _textRef.text)
            : ListView(children: [
                const VSpaceShort(),
                TagHistory(key: _historyKey, onTagTap: _handleTagTap),
                const VSpaceBig(),
                TagTrending(onTagTap: _handleTagTap),
                const VSpaceShort(),
              ]));
  }
}
