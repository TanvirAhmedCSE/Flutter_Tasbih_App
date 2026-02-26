import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasbih Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF7B5EA7)),
        useMaterial3: true,
        fontFamily: 'Segoe UI',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;
  int themeIndex = 0;
  bool isRunning = false; // true means running false means paused
  bool toggleValue = false;
  int seconds = 0;
  Timer? myTimer;

  // all theme images and colors
  List<String> imageUrls = [
    'https://media.istockphoto.com/id/1400534478/photo/muslim-men-raise-their-hands-to-pray-with-a-tasbeeh-on-dark-background-indoors-focus-on-hands.jpg?s=612x612&w=0&k=20&c=8p6gvOoEVIui2DIWlYCSqFnQ1AUOGl71-eQckO-2epc=',
    'https://static.vecteezy.com/system/resources/thumbnails/002/180/148/small/man-praying-during-ramadan-photo.jpg',
    'https://images.pexels.com/photos/16197226/pexels-photo-16197226/free-photo-of-a-person-holding-a-rosary-in-their-hands.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://media.istockphoto.com/id/534133548/photo/hand-of-muslim-people-praying.jpg?s=612x612&w=0&k=20&c=16x-rIttLsPmbwgPx82Yt0NQALguVKSUtdNcBkvTeSg=',
    'https://static.vecteezy.com/system/resources/thumbnails/039/668/113/small/close-up-of-man-s-hands-praying-with-prayer-beads-photo.jpg',
    'https://cdn.create.vista.com/api/media/small/267653054/stock-photo-prayer-hands-of-a-woman-holding-a-rosary',
  ];

  List<Color> overlayColors = [
    Colors.black.withValues(alpha: 0.55),
    Color(0xFF1A237E).withValues(alpha: 0.65),
    Color(0xFF7B5EA7).withValues(alpha: 0.60),
    Colors.green.withValues(alpha: 0.50),
    Color(0xFF00695C).withValues(alpha: 0.40),
    Color(0xFF4A148C).withValues(alpha: 0.60),
  ];

  List<Color> navbarColors = [
    Colors.black.withValues(alpha: 0.80),
    Color(0xFF1A237E).withValues(alpha: 0.65),
    Color(0xFF7B5EA7).withValues(alpha: 0.80),
    Colors.green.withValues(alpha: 0.70),
    Color(0xFF00695C).withValues(alpha: 0.40),
    Color(0xFF4A148C).withValues(alpha: 0.60),
  ];

  @override
  void initState() {
    super.initState();
    startMyTimer();
  }

  void startMyTimer() {
    myTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isRunning == true) {
        setState(() {
          seconds = seconds + 1;
        });
      }
    });
  }

  @override
  void dispose() {
    myTimer!.cancel();
    super.dispose();
  }

  // convert seconds to hours minutes seconds format
  String getTime() {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    String hStr = h.toString();
    String mStr = m.toString().padLeft(2, '0');
    String sStr = s.toString().padLeft(2, '0');
    return '$hStr:$mStr:$sStr';
  }

  // increase count by 1
  void addCount() {
    setState(() {
      count = count + 1;
    });
  }

  // reset everything
  void resetAll() {
    setState(() {
      count = 0;
      seconds = 0;
      isRunning = true;
    });
  }

  // pause the counter
  void pauseCounter() {
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // decide color based on running or paused
    Color numColor;
    if (isRunning == true) {
      numColor = Colors.white;
    } else {
      numColor = Colors.red.shade300;
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        leading: BackButton(color: Colors.black87),
        title: Text(
          'Tasbih Counter',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0,
        actions: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.black87,
                size: 25,
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COUNTER CARD
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // background image with overlay
                  Container(
                    height: 420,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrls[themeIndex],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Color(0xFF7B5EA7));
                          },
                        ),
                        Container(color: overlayColors[themeIndex]),
                      ],
                    ),
                  ),

                  // all the buttons and text
                  Container(
                    height: 420,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الله أكبر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),

                        // timer display
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isRunning
                                ? Colors.white.withValues(alpha: 0.25)
                                : Colors.red.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: isRunning
                                  ? Colors.transparent
                                  : Colors.red.withValues(alpha: 0.55),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            getTime(),
                            style: TextStyle(
                              color: numColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        Text(
                          'Tasbih Counter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // count number
                        Text(
                          count.toString().padLeft(3, '0'),
                          style: TextStyle(
                            color: numColor,
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),

                        // toggle switch
                        GestureDetector(
                          onTap: () {
                            if (isRunning == false)
                              return; // do nothing if stopped or paused
                            setState(() {
                              toggleValue = !toggleValue;
                              addCount(); // increase count every time toggle is tapped
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withValues(alpha: 0.35),
                              // red border when stopped or paused
                              border: Border.all(
                                color: isRunning
                                    ? Colors.transparent
                                    : Colors.red.shade400,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                AnimatedAlign(
                                  duration: Duration(milliseconds: 200),
                                  alignment: toggleValue
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // red circle when stopped or paused
                                      color: isRunning
                                          ? Colors.white.withValues(alpha: 0.8)
                                          : Colors.red.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // three buttons at bottom
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // reset button
                            GestureDetector(
                              onTap: () {
                                resetAll();
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.black87,
                                  size: 26,
                                ),
                              ),
                            ),

                            // stop button
                            GestureDetector(
                              onTap: isRunning ? pauseCounter : null,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                width: 80,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isRunning
                                      ? Colors.white.withValues(alpha: 0.85)
                                      : Colors.white.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    'Stop',
                                    style: TextStyle(
                                      color: isRunning
                                          ? Colors.black87
                                          : Colors.white54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // play or pause button
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isRunning == true) {
                                    isRunning = false;
                                  } else {
                                    isRunning = true;
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  // glow when paused so user knows to press it, it will be helpful for user
                                  color: isRunning == false
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: isRunning == false
                                      ? [
                                          BoxShadow(
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Icon(
                                  isRunning ? Icons.pause : Icons.play_arrow,
                                  color: isRunning == false
                                      ? Color(0xFF5B3A8A)
                                      : Colors.black87,
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Add Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),

            // THEMES GRID
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      themeIndex = index; // change theme
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey[400]);
                          },
                        ),
                        Container(color: overlayColors[index]),
                        // show white border if this theme is selected, so it will be visible: this theme is selected
                        if (themeIndex == index)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // END THEMES GRID
            SizedBox(height: 24),
          ],
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: navbarColors[themeIndex],
        selectedItemColor: Colors.yellow.shade300,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            activeIcon: Icon(Icons.access_time),
            label: 'Shedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        onTap: (index) {},
      ),
    );
  }
}
