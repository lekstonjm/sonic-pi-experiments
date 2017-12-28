s.boot;

(
x = { MouseX.kr.linexp(0,1,30,3000).poll }.play;
)

(
x={
	arg amp=0.3;
	var sig, filter, freq, harm ;
	freq = MouseX.kr.linexp(0,1,30,3000).round(30);
	harm = MouseY.kr.linlin(0,1,1,10).round(1);
	sig = ([Saw.ar(freq), Saw.ar(freq+1)] + PinkNoise.ar(0.5)) * amp;
	filter = RLPF.ar(sig,freq*harm, 0.1,0.1);
}.play;
)

x = { RLPF.ar(Saw.ar(200, 0.1), FSinOsc.kr(XLine.kr(0.7, 300, 20), 0, 3600, 4000), 0.2) }.play;

(
x = {     var ctl = RLPF.ar(Saw.ar(5, 0.1), 25, 0.03);
    SinOsc.ar(ctl * 200 + 400) * 0.1;
}.play;
)

(
x = {     var ctl = RLPF.ar(Saw.ar(5,0.1), MouseX.kr(2, 200, 1), MouseY.kr(0.01, 1, 1));
    SinOsc.ar(ctl * 200 + 400) * 0.1;
}.play;
)

x.free;
x.set(\amp,0.6);

s.plotTree;
s.meter;

s.defaultGroup.freeAll;

s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;
s.reboot;