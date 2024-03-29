import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class VolumSlider extends StatefulWidget {
  const VolumSlider({super.key});

  @override
  State<VolumSlider> createState() => _VolumSliderState();
}

class _VolumSliderState extends State<VolumSlider> {
  double _volumeValue = 50; 

Future<void> onVolumeChanged(double value)async {
await  MusicProvider.instance.setVolume(value/100);
  setState(() {
    log(value.toString())
;    _volumeValue = value;
  });
}
String timeFormate(int time){
  return (time/60).toString().padLeft(2,'0');
}
  @override
  Widget build(BuildContext context) {
    return Transform.flip(flipX: true,
                child:SfRadialGauge(
       axes: <RadialAxis>[
                RadialAxis(minimum: 0,
                startAngle: 0,endAngle: -180,
       maximum: 100,
       showLabels: false,
       showTicks: true,majorTickStyle: const MajorTickStyle(thickness: 1,length: 5),
       tickOffset: 5,
       ticksPosition: ElementsPosition.outside,
       radiusFactor: 1,
       axisLineStyle: const AxisLineStyle(
           cornerStyle: CornerStyle.bothCurve,
           color: Color.fromARGB(255, 79, 77, 83),
           thickness: 7),
       pointers: <GaugePointer>[
         RangePointer(
             value: _volumeValue,
             cornerStyle: CornerStyle.bothCurve,
             width: 7,
             sizeUnit: GaugeSizeUnit.logicalPixel,
             gradient: const SweepGradient(
                 colors: <Color>[
                   Color(0xFFCC2B5E),
                   Color(0xFF753A88)
                 ],
                 stops: <double>[0.25, 0.75]
             )),
         MarkerPointer(
             value: _volumeValue,
             enableDragging: true,
             onValueChanged:(value)async=>await onVolumeChanged(value),
             markerHeight: 20,
             markerWidth: 20,
             markerType: MarkerType.circle,
             color: const Color(0xFF753A88),
             borderWidth: 5,
             borderColor: Colors.white),
       ],
       annotations: const <GaugeAnnotation>[
        
       ]
                )
       ]
                ));
  }
}