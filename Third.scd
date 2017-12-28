s.boot;
s.freeAll;

(
SynthDef(\test, {
	arg freq = 440, t_gate = 0;
	var sig, env;
	env = EnvGen.ar(Env.perc,gate: t_gate);
	sig = Pulse.ar(freq)*env;
	Out.ar(0,sig!2);
}).add;
);

(
SynthDef(\test2, {
	arg freq = 440, t_gate = 0, amp = 0.1, detune = 0.01;
	var sig, env;
	env = EnvGen.ar(Env.perc,gate: t_gate);
	sig = 0.0;
	5.do({
		arg i;
		var harmony = freq * (1.0 + i)*rrand(1.0-detune,1+detune);
		sig = sig +  SinOsc.ar(harmony);
	});
	sig = sig * amp * env;
	Out.ar(0,sig!2);
}).add;
);


( x={SinOsc.ar(mul:0.1)}.scope;)

x.free;
a.free;
a = Synth.new(\test2);
a.scope;
a.set(\t_gate,1,\freq, 40.midicps, \detune, 0.09);

(
~melodie = Routine.new({
	[60,60,60,66,60,65,60,67,68].do( {
		arg midi;
		a.set(\t_gate,1,\freq, midi.midicps);
		0.4.wait;
	});
});
)


~melodie.play;
~melodie.reset;
s.plotTree;

rrand(1.0,2.0);