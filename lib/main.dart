import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Now Playing',
      home: const NowPlayingScreen(),
    );
  }
}

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------- 1. BACKGROUND GRADIENT ----------
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB08B5B), // warm tan top
              Color(0xFF3A2A1E), // dark brown bottom
              Color(0xFF1A120C), // near-black
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---------- 2. DRAG HANDLE ----------
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

             // ---------- 3. ALBUM ART ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 340,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: const DecorationImage(
                      image: AssetImage('Assets/boston.jpeg'),
  fit: BoxFit.cover,
),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ---------- 4. SONG INFO ROW ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'The Boston Drama',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Typecast',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.add_circle_outline,
                            color: Colors.white, size: 26),
                        SizedBox(width: 18),
                        Icon(Icons.favorite_border,
                            color: Colors.white, size: 24),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ---------- 5. PROGRESS BAR ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.45,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(-0.1, 0),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('1:19',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 12)),
                        Text('-1:39',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ---------- 6. PLAYBACK CONTROLS ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.shuffle, color: Colors.white70, size: 22),
                    const Icon(Icons.skip_previous,
                        color: Colors.white, size: 34),
                    Container(
                      width: 66,
                      height: 66,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.pause,
                          color: Colors.black, size: 34),
                    ),
                    const Icon(Icons.skip_next, color: Colors.white, size: 34),
                    const Icon(Icons.repeat, color: Colors.white70, size: 22),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ---------- 7. DEVICE ROW ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: const [
                    Icon(Icons.bluetooth, color: Colors.greenAccent, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'AirPods Max',
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ---------- 8. OUTPUT / MENU ROW ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.playlist_play,
                            color: Colors.white70, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'TYPECAST',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.dark_mode_outlined,
                            color: Colors.white70, size: 20),
                        SizedBox(width: 18),
                        Icon(Icons.ios_share, color: Colors.white70, size: 20),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ---------- 9. LYRICS PANEL ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 18),
                decoration: const BoxDecoration(
                  color: Color(0xFFC9A876),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lyrics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.open_in_full,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}