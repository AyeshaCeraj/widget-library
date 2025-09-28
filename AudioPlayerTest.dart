import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final player = AudioPlayer();
  int currentIndex = 0; // track current ayah
  final int totalAyahs = 7;
  bool isPlayingAll = false; // play all state
  bool isPaused = false; // pause state

  @override
  void initState() {
    super.initState();

    // jab ek audio khatam ho jaye to next play ho
    //listner hai
    player.onPlayerComplete.listen((event) {
      print("current index $currentIndex");
      if (isPlayingAll && currentIndex < totalAyahs) {
        playAyah(currentIndex); // play next
      }
    });
  }

  Future<void> playAyah(int index) async {
    setState(() {
      currentIndex = index + 1;
      isPaused = false;

    });
    await player.play(
      UrlSource(
          'https://cdn.islamic.network/quran/audio/64/ar.alafasy/${index + 1}.mp3'),
    );
  }

  Future<void> playAll() async {
    setState(() {
      isPlayingAll = true;
      currentIndex = 0;
      isPaused = false;
    });
    await playAyah(currentIndex);
  }

  Future<void> pauseAll() async {
    await player.pause();
    setState(() {
      isPaused = true;
    });
  }

  Future<void> resumeAll() async {
    await player.resume();
    setState(() {
      isPaused = false;
    });
  }

  Future<void> stopAll() async {
    await player.stop();
    setState(() {
      isPlayingAll = false;
      isPaused = false;
      currentIndex = 0; // reset
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play all button

            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: playAll,
              child: const Text('Play All (1-7)'),
            ),

            // Pause button
            ElevatedButton(
              onPressed: pauseAll,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Pause'),
            ),

            // Resume button
            ElevatedButton(
              onPressed: isPaused ? resumeAll : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Resume'),
            ),

            // Stop button
            ElevatedButton(
              onPressed: stopAll,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Stop'),
            ),
            Text('$currentIndex'),

            Expanded(
              child: ListView.builder(
                itemCount: totalAyahs,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Ayah ${index + 1}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () async {
                        await player.play(
                          UrlSource(
                              'https://cdn.islamic.network/quran/audio/64/ar.alafasy/${index + 1}.mp3'),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
