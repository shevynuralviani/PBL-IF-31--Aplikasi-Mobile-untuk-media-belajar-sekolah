import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:genetika_app/screen/navbar/custom_appbar.dart';
import 'package:genetika_app/screen/navbar/bottom_bar.dart';
import 'package:genetika_app/screen/siswa/materi.dart';
import 'package:genetika_app/screen/siswa/videopage.dart';
import 'package:genetika_app/screen/siswa/favoritpage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const HomeSiswa());
}

class HomeSiswa extends StatefulWidget {
  const HomeSiswa({super.key});

  @override
  _HomeSiswaState createState() => _HomeSiswaState();
}

class _HomeSiswaState extends State<HomeSiswa> {
  int _selectedIndex = 0; // Track selected bottom nav item

  // List halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const MyHomePage(),
    const MateriPage(),
    VideoPage(),
    FavoritePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyCustomAppBar(),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isStarSelected = false; // Track star icon state
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Carousel Slider section
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 5),
                scrollDirection: Axis.horizontal,
              ),
              items: [
                'https://cdn-web-2.ruangguru.com/landing-pages/assets/9f0a16b3-dd8b-4c96-b278-783c0fb9aed3.png',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcF5wCpjrjpmg0Tt4WPy5w1U605xRGwL_ltw&s',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6hdv_TEkVcUoBGuq74Dhz9GLCPXZeFsjBfA&s',
              ].map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Calendar section
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFB4D924), // Background color of the calendar
                  borderRadius: BorderRadius.circular(15), // Adding border radius
                ),              
                child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: CalendarFormat.week,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, 
                ),
                todayDecoration: BoxDecoration(
                color: Colors.white,
                  shape: BoxShape.circle,
                ),
                  todayTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Reading Progress Section
            const Text(
              'Lanjutkan Membaca',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7BBB07).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 65,
                        height: 80,
                        color: const Color(0xFFB4D924),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enzim Dan Metabolisme',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text('Biology, Bab 1'),
                          const SizedBox(height: 5),
                          Column(
                            children: [
                              const Text('Page 11 from 50 (40%)'),
                              const SizedBox(height: 10),
                              Container(
                                width: 150,
                                child: LinearProgressIndicator(
                                  value: 0.4,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7BBB07)),
                                  minHeight: 5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Icon bintang di pojok kanan atas
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isStarSelected = !_isStarSelected;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: _isStarSelected ? const Color(0xFF7BBB07) : Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
