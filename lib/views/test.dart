// import 'dart:ui';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:somni_app/controller/network_controller.dart';
// import 'package:somni_app/controller/player_controller.dart';

// class PlayeAudioScreen extends ConsumerStatefulWidget {
//   final int index;
//   const PlayeAudioScreen({required this.index, Key? key}) : super(key: key);

//   @override
//   _PlayeAudioScreen createState() => _PlayeAudioScreen();
// }

// AudioPlayer player = AudioPlayer();

// class _PlayeAudioScreen extends ConsumerState<PlayeAudioScreen> {
//   //setting the project url
//   // String imgCoverUrl =
//   //     "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";

//   bool isPlaying = false;
//   double value = 0;

//   Duration? duration;

//   void initPlayer() async {
//     final controller = ref.read(networkProvider.notifier);

//     await player.setSource(
//         DeviceFileSource(controller.cachedAudios[widget.index].path));
//     duration = await player.getDuration();
//     setState(() {});
//   }

//   //init the player
//   @override
//   void initState() {
//     super.initState();
//     initPlayer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = ref.read(networkProvider.notifier);
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             constraints: const BoxConstraints.expand(),
//             height: 300.0,
//             width: 300.0,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/cover.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
//               child: Container(
//                 color: Colors.black.withOpacity(0.6),
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               //setting the music cover
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(30.0),
//                 child: Image.asset(
//                   "assets/cover.jpg",
//                   width: 250.0,
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               Text(
//                 controller.cachedAudios[widget.index].name.split('.')[0],
//                 style: const TextStyle(
//                     color: Colors.white, fontSize: 36, letterSpacing: 6),
//               ),
//               //Setting the seekbar
//               const SizedBox(height: 50.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "${(value / 60).floor()}: ${(value % 60).floor()}",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   SizedBox(
//                     width: 260.0,
//                     child: Slider.adaptive(
//                       onChangeEnd: (newVvalue) async {
//                         setState(() {
//                           value = newVvalue;
//                           print(newVvalue);
//                         });
//                         await player.seek(Duration(seconds: newVvalue.toInt()));
//                       },
//                       min: 0.0,
//                       value: value,
//                       max: 214.0,
//                       onChanged: (value) {},
//                       activeColor: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     "${duration?.inMinutes} : ${(duration?.inSeconds ?? 0) % 60}",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//               //setting the player controller
//               const SizedBox(
//                 height: 60.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(60.0),
//                       color: Colors.black87,
//                       border: Border.all(color: Colors.white38),
//                     ),
//                     width: 50.0,
//                     height: 50.0,
//                     child: InkWell(
//                       onTapDown: (details) {
//                         player.setPlaybackRate(0.5);
//                       },
//                       onTapUp: (details) {
//                         player.setPlaybackRate(1);
//                       },
//                       child: const Center(
//                         child: Icon(
//                           Icons.fast_rewind_rounded,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 20.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(60.0),
//                       color: Colors.black87,
//                       border: Border.all(color: Colors.pink),
//                     ),
//                     width: 60.0,
//                     height: 60.0,
//                     child: InkWell(
//                       onTap: () async {
//                         //setting the play function
//                         await player.resume();
//                         player.onPositionChanged.listen(
//                           (Duration d) {
//                             setState(() {
//                               value = d.inSeconds.toDouble();

//                               print(value);
//                             });
//                           },
//                         );
//                         print(duration);
//                       },
//                       child: const Center(
//                         child: Icon(
//                           Icons.play_arrow,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(60.0),
//                       color: Colors.black87,
//                       border: Border.all(color: Colors.white38),
//                     ),
//                     width: 50.0,
//                     height: 50.0,
//                     child: InkWell(
//                       onTapDown: (details) {
//                         player.setPlaybackRate(2);
//                       },
//                       onTapUp: (details) {
//                         player.setPlaybackRate(1);
//                       },
//                       child: const Center(
//                         child: Icon(
//                           Icons.fast_forward_rounded,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
