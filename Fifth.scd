s.boot;
~organ1 = Buffer.read(s,"/home/jm/Bureau/Samples/HipHop/Keys/ORGAN001_HPHOP_90_A_SC1.wav");

~organ2 = Buffer.read(s,"/home/jm/Bureau/Samples/HipHop/Keys/ORGAN002_HPHOP_90_A_SC1.wav");

~loop = Buffer.read(s,"/home/jm/Bureau/Samples/HipHop/Loop/DRUMLOOP045_HPHOP_90_X_SC1.wav");

~organ2.play;
~organ1.play;
~loop.play(true);
(
x={
	arg amp=0.3;
	var sig, filter, freq, harm, dry ;
	freq = MouseX.kr.linexp(0,1,30,3000).round(30);
	harm = MouseY.kr.linlin(0,1,1,10).round(1);
	dry = MouseY.kr;
	sig = ([Saw.ar(freq), Saw.ar(freq+1)] + PinkNoise.ar(0.8)) * amp;
	//filter = sig * dry + RLPF.ar(sig,freq*harm, 0.1,0.1) * (1.0 - dry);
}.play;
)


(
x={
	arg amp=0.3;
	var sig, filter, freq, harm, dry ;
	freq = MouseX.kr.linexp(0,1,30,3000).round(30);
	harm = MouseY.kr.linlin(0,1,1,10).round(1);
	dry = MouseY.kr;
	sig = ([Saw.ar(freq), Saw.ar(freq+1)] + PinkNoise.ar(0.8)) * amp;
	//filter = sig * dry + RLPF.ar(sig,freq*harm, 0.1,0.1) * (1.0 - dry);
}.play;
)


x.set(\amp, 0.7);

x.free;

s.defaultGroup.freeAll;
s.quit;
s.plotTree;