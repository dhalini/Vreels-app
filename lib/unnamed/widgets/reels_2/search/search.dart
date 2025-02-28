import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/profile/media_grid.dart';
import 'package:prototype25/unnamed/widgets/reels_2/search/search_tabs.dart';
import 'package:prototype25/unnamed/widgets/reels_2/search/suggestion_item.dart';
import 'package:prototype25/utils/mock_api/pexels_api_service.dart';



class SearchPage extends StatefulWidget {
  final String? initialQuery;
  const SearchPage({Key? key, this.initialQuery}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedTabIndex = 0;

  
  List<Map<String, dynamic>> _photoUrls = [];
  List<Map<String, dynamic>> _videoUrls = [];

  
  List<String> _users = ["Alice", "Bob", "Charlie", "Daisy"];

  late TextEditingController _searchController;
  bool _hasSearched = false;

  
  List<String> typedSearches = [
    'bulldog',
    'englishbulldog',
    'dog funny videos',
  ];

  
  final List<SuggestionItem> suggestions = [
    SuggestionItem(
      text: 'kj passed away',
      bulletColor: Colors.red,
      textColor: Colors.red,
      isBold: true,
      justWatched: false,
    ),
    SuggestionItem(
      text: 'Funny Dogs',
      bulletColor: Colors.pink,
      textColor: Colors.pink,
      isBold: true,
      justWatched: true,
    ),
    SuggestionItem(
      text: 'English Bulldogs',
      justWatched: true,
    ),
    
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  
  void _onSearchPressed() async {
    FocusScope.of(context).unfocus();
    String query = _searchController.text.trim();
    query = query.startsWith('#') ? query.substring(1) : query;
    setState(() {
      _hasSearched = true;
    });
    
    await _fetchContentForTab(_selectedTabIndex, query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildCustomAppBar(),
      body: _hasSearched
          ? _buildSearchedUI() 
          : _buildTypingSuggestionsUI(), 
    );
  }

  
  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Container(
          height: 36,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onTap: () {
                    setState(() {
                      
                      _hasSearched = false;
                    });
                  },
                  textInputAction:
                      TextInputAction.search, 
                  onSubmitted: (value) => _onSearchPressed(),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    suffixIcon: IconButton(
                      onPressed: () {
                        
                      },
                      icon: const Icon(Icons.mic, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _onSearchPressed,
            child: const Text(
              'Search',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildTypingSuggestionsUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        if (typedSearches.isNotEmpty)
          Column(
            children: typedSearches.map((search) {
              return ListTile(
                leading: const Icon(Icons.access_time, color: Colors.grey),
                title: Text(
                  search,
                  style: const TextStyle(fontSize: 15),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    setState(() => typedSearches.remove(search));
                  },
                ),
                onTap: () {
                  setState(() {
                    _searchController.text = search;
                  });
                },
              );
            }).toList(),
          ),

        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            children: [
              const Text(
                'You may like',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  
                },
                child: Row(
                  children: const [
                    Icon(Icons.refresh, size: 18, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Refresh',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        
        Expanded(
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return _buildSuggestionTile(suggestions[index]);
            },
          ),
        ),
      ],
    );
  }

  
  Widget _buildSearchedUI() {
    
    String query = _searchController.text.trim();
    query = query.startsWith('#') ? query.substring(1) : query;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        SearchTabs(
          selectedIndex: _selectedTabIndex,
          onTabChanged: (int newIndex) async {
            setState(() => _selectedTabIndex = newIndex);

            
            await _fetchContentForTab(newIndex, query);
          },
        ),

        
        Expanded(
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _buildTabContent()),
        ),
      ],
    );
  }

  Future<void> _fetchContentForTab(int tabIndex, String query) async {
    try {
      switch (tabIndex) {
        case 0: 
          final fetchedPhotos = await PexelsApiService.fetchPhotos(query);
          final fetchedVideos = await PexelsApiService.fetchVideos(query);
          setState(() {
            _photoUrls = fetchedPhotos;
            _videoUrls = fetchedVideos;
          });
          break;

        case 1: 
          
          break;

        case 2: 
          final fetchedPhotos = await PexelsApiService.fetchPhotos(query);
          setState(() {
            _photoUrls = fetchedPhotos;
            _videoUrls = []; 
          });
          break;

        case 3: 
          final fetchedVideos = await PexelsApiService.fetchVideos(query);
          setState(() {
            _videoUrls = fetchedVideos;
            _photoUrls = []; 
          });
          break;
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: 
        return _buildMixOfPhotosAndVideosUI();
      case 1: 
        return _buildUsersList();
      case 2: 
        return _buildPhotosUI();
      case 3: 
        return _buildVideosUI();
      default:
        return const SizedBox();
    }
  }

  Widget _buildMixOfPhotosAndVideosUI() {
    
    final combined = [..._photoUrls, ..._videoUrls];

    if (combined.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return MediaGrid(data: combined, onTap: _openUrl);

    
    
    
    
    
    
    
    
    
    
  }

  Widget _buildUsersList() {
    
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(_users[index]),
        );
      },
    );
  }

  void _openUrl(String url) {
    print('Opening URL: $url');
    
  }

  Widget _buildPhotosUI() {
    print("called here ${_photoUrls}");
    if (_photoUrls.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return MediaGrid(data: _photoUrls, onTap: _openUrl);

    
    
    
    
    
    
    
    
    
    
    
  }

  Widget _buildVideosUI() {
    if (_videoUrls.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return MediaGrid(data: _videoUrls, onTap: _openUrl);

    
    
    
    
    
    
    
    
    
    
  }

  Widget _buildSuggestionTile(SuggestionItem item) {
    return ListTile(
      leading:
          Icon(Icons.circle, size: 8, color: item.bulletColor ?? Colors.grey),
      title: Text(
        item.text,
        style: TextStyle(
          color: item.textColor,
          fontWeight: item.isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 15,
        ),
      ),
      trailing: item.justWatched
          ? const Text('Just watched',
              style: TextStyle(color: Colors.grey, fontSize: 13))
          : null,
      onTap: () {
        setState(() {
          _searchController.text = item.text;
        });
      },
    );
  }
}
