s.reboot;
(
SynthDef("FM0", {
	arg car_freq = 440, mod1_ratio = 3.25, mod1_factor = 500, mod1_feedback_factor = 1.0, amp = 1.0, gate = 1;

	var env1 = EnvGen.kr(Env.linen(sustainTime:0), doneAction: 0);
	var op1_feedback = LocalIn.ar(1)* mod1_feedback_factor;
	var op1_freq = car_freq * mod1_ratio + op1_feedback;
	var op1 = SinOsc.ar(op1_freq) * mod1_factor * env1 ;

	var env2 = EnvGen.kr(Env.linen, gate:gate, doneAction: 2);
	//var env2 = 1.0;
	var op2_freq = car_freq + op1;
	var op2 = SinOsc.ar( op2_freq );


	var signal = op2*env2*amp;
	LocalOut.ar(op1);
	Out.ar([0,1], signal);
}).add;
)
x = Synth.new("FM0", ["amp",0.5, "mod1_feedback_factor", 0.0]);
x.set(\gate,0);
x.free;




(
SynthDef(\cfstring1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99, 1.01), Rand(0.99, 1.01)], 0, amp) }).distort * 0.2;
    eg = EnvGen.kr(Env.asr(1, 1, 1), gate, doneAction:2);
    out = eg * RLPF.ar(osc, fc, 0.1);
    #a, b = out;
    Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).add;
)
(
e = Pbind(
    \car_freq, Pseq((60..72).midicps, inf),
    \dur, 1,
    \instrument, \FM1
).play; // returns an EventStream
)
s.plotTree
treeView
s.treeView
s.quit
s.boot

e.free
e.stop
e.play
e.reset

e.mute; // keeps playing, but replaces notes with rests

e.unmute;

e.reset; // reset the stream.
e.reset; // reset the stream.
e.reset; // reset the stream.
e.reset; // reset the stream.

e.pause; // will resume where paused.

e.play;

e.stop; // will reset before resume.

e.play