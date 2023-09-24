import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

const String API_KEY =
    'tLLFbgWVeyvt2Onc1QYv0R1BZ3IfLH7iT7zduYlsHkDyB8eSpddwR2th';

class PexelsImageSearch extends StatefulWidget {
  @override
  _PexelsImageSearchState createState() => _PexelsImageSearchState();
}

class _PexelsImageSearchState extends State<PexelsImageSearch> {
  List<dynamic> _images = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchImages(String query) async {
    setState(() {
      _isLoading = true;
    });

    String url = 'https://api.pexels.com/v1/search?query=$query&per_page=30';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': API_KEY,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _images = data['photos'];
        _isLoading = false;
      });
    } else {
      print('Failed to load images');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pexels Image Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => _debouncedSearch(query),
              decoration: InputDecoration(
                hintText: 'Search images...',
              ),
            ),
          ),
          Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _images.isEmpty
                      ? Center(child: Text('Search anything you want.'))
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            String imageUrl = _images[index]['src']['medium'];
                            return CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            );
                          },
                        )),
        ],
      ),
    );
  }

  Timer? _debounceTimer;

  void _debouncedSearch(String query) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _searchImages(query);
    });
  }
}
