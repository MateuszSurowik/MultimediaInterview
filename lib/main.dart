import 'package:flutter/material.dart';
import 'package:multimedia/utills/asstes_list.dart';
import 'package:multimedia/utills/title_list.dart';
import 'package:multimedia/widgets/Buttons/circle_button.dart';
import 'package:multimedia/widgets/custom_card.dart';
import 'package:multimedia/widgets/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SlaskieScreen(),
    );
  }
}

class SlaskieScreen extends StatefulWidget {
  const SlaskieScreen({super.key});

  @override
  State<SlaskieScreen> createState() => _SlaskieScreenState();
}

class _SlaskieScreenState extends State<SlaskieScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _scaleAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = true;
          });
        }
      } else {
        if (_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = false;
          });
        }
      }
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;

      if (_isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  // Scroll to the top
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavBarBuilder(),
      body: Stack(
        children: [
          Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(177, 227, 236, 236)),
            child: Column(
              children: [
                // Animated AppBar
                _animatedContainerBuilder(),
                _headerSection(),
                _gridViewSection(context),
              ],
            ),
          ),

          // Scroll to top button
          _showScrollToTopButton
              ? Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _scrollToTop,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // Make grid responsive based on the orientation
  Expanded _gridViewSection(BuildContext context) {
    int crossAxisCount =
        MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3;

    return Expanded(
      child: GridView.count(
        controller: _scrollController,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(assetPaths.length, (index) {
          return CustomCard(
            color: Colors.teal,
            title: titleList[index],
            image: assetPaths[index],
          );
        }),
      ),
    );
  }

  Padding _headerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Polecane',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? Colors.transparent
                      : Colors.green,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_more : Icons.expand_less,
                    color: Colors.white,
                  ),
                  onPressed: _toggleExpanded,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(30, 30),
                  backgroundColor: const Color.fromARGB(197, 167, 145, 231),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Płatne',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(30, 30),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Bezpłatne',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AnimatedContainer _animatedContainerBuilder() {
    double containerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 450.0
            : 200.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: _isExpanded ? containerHeight : 125,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SafeArea(
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: _isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: VideoPlayerWidget(),
              ),
            ),
            Center(
              child: SlideTransition(
                position: _slideAnimation,
                child: _isExpanded
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Image.asset(
                            'assets/images/logo_white.png',
                            height: 120,
                            width: 120,
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/logo_slaskie.png',
                        height: 100,
                        width: 100,
                      ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: CircleButton(
                icon: Icons.menu,
                onPressed: () {},
              ),
            ),
            Positioned(
              top: 20,
              right: 60,
              child: CircleButton(
                icon: Icons.favorite_border,
                onPressed: () {},
              ),
            ),
            Positioned(
              top: 20,
              right: 5,
              child: CircleButton(
                icon: Icons.search,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavBarBuilder() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.black,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: _selectedIndex == 0
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home, color: Colors.white),
                )
              : const Icon(Icons.home),
          label: 'Śląskie',
        ),
        BottomNavigationBarItem(
          icon: _selectedIndex == 1
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.newspaper_outlined, color: Colors.white),
                )
              : const Icon(Icons.newspaper_outlined),
          label: 'Aktualności',
        ),
        BottomNavigationBarItem(
          icon: _selectedIndex == 2
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.date_range_outlined,
                      color: Colors.white),
                )
              : const Icon(Icons.date_range_outlined),
          label: 'Wydarzenia',
        ),
        BottomNavigationBarItem(
          icon: _selectedIndex == 3
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.map_outlined, color: Colors.white),
                )
              : const Icon(Icons.map_outlined),
          label: 'Eksploruj',
        ),
      ],
    );
  }
}
