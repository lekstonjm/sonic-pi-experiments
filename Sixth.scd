s.boot;
(
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;
s.reboot;
s.plotTree;
s.meter;
)



(
SynthDef(\sin,{
	arg freq=440, detune=0, atk=0.01, rel=1, amp=0.5, out=0;
	var env, osc, sig;
	env = EnvGen.kr(Env.perc(atk, rel,0.5),doneAction: 2);
	osc = SinOsc.ar(freq,0,0.5);
	sig = osc * env * amp;
	Out.ar(out,sig!2);
}).add;
)

(
x=Synth.new(\sin);
)

t = TempoClock.new(120/60);

(
t.play({
	t.beats.postln;
	t.bar.postln;
	1;
});
)

(
Pbindef(\a
	,\instrument,\sin
	,\note, Pseq([0,3,15], inf)
).play(t);
)
Pbindef(\a).stop;

t.stop;
t.clear;

s.reboot;

s.freeAll;
s.quitAll;
s.quit;
s.boot;