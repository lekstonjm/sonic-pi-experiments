s.boot;

(
 //TV DETUNE
 ~detuned =
{
	arg freq = 55.0, amp = 0.01;
	Pulse.ar(freq, 0.05) * amp ! 2
}.play;
)

(
~bit = {
	arg bit_freq = 12;
	var env, filter;
	env = EnvGen.ar(envelope: Env.perc(releaseTime:0.1), doneAction:2);

	Pulse.ar(freq: bit_freq) * PinkNoise.ar() * env ! 2;
}.play;
)
~detuned.free;

~detuned.set(\freq,55.0);
s.freeAll;

s.plotTree;