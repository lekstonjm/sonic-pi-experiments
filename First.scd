s.boot;
s.reboot;
s.quit;
s.freqscope;

x = {[0,0.1*Blip.ar(440,10)]}.play;
x.free;


(
~bubble = {
	var f, zout;
	f = LFSaw.kr(0.4, 0, 24, LFSaw.kr([8,7.23], 0, 3, 80)).midicps; // glissando function
	zout = CombN.ar(SinOsc.ar(f, 0, 0.04), 0.2, 0.2, 4); // echoing sine wave
	Out.ar(0, zout);
}.play;
)

~bubble.free;

(
~bubble2 = {
({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)
* 400 + 500, 0.03, 0.003)}!2)
+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)
* 800 + 1000, 0.03, 0.005)}!2)
* 4
}.play;
)
~bubble2.free;

{ CombN.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;

{ CombL.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;

{ CombC.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;

// with negative feedback:
{ CombN.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), -0.2) }.play;

{ CombL.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), -0.2) }.play;

{ CombC.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), -0.2) }.play;

// used as an echo.
{ CombN.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.play;

x = { Dust.ar(200)}.play;
x.free;

x = { Decay.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.2, PinkNoise.ar, 0) }.play;
x.free;

(
SynthDef ("module", {
	arg freq = 400, mod = 0;
	var signal;
	signal = SinOsc.ar(freq + mod);
	Out.ar(0,[signal,signal]);
}).add;
)

(
~x1 = Synth.new("module", ["mod",Synth("module")]);
)

~x1.free;

(
~x2 = {
	arg freq = 400, mod = 0;
	var signal;
	signal = SinOsc.ar(freq + mod);
	Out.ar(0,[signal,signal]);
};
)

~x2.free;
FreqScope.new;

(
SynthDef ("type1", {
	arg freq = 400, mod_freq = 10, mod_factor = 0;
	var sig, mod ;
	mod = SinOsc.ar(mod_freq);
	sig = SinOsc.ar(freq + SinOsc.ar(mod_freq)*1);
	Out.ar(0,[sig,sig]);
}).add;
)

x={SinOsc.ar(200 + (SinOsc.ar(200*4) * 300))}.play;
x.free;
(
~x1 = Synth.new("type1");
)
{EnvGen.kr(Env.linen)}.plot;
)~x1.free;
(
SynthDef(\FM, { |car_freq, mod_ratio, mod_index, amp |
    var fm = SinOsc.ar(car_freq + (SinOsc.ar(car_freq*mod_ratio) * mod_index));
    var env = EnvGen.kr(Env.linen, doneAction: 2);
    var signal = env*fm;
	Out.ar(0, [signal,signal]);
}).add;
)
x = Synth.new(\FM, [\car_freq, 440, \mod_ratio, 3.25, \mod_index, 500]);
x.free;
// 3 Oscillators
(
SynthDef(\FM3OP, { |car_freq, mod_ratio1, mod_ratio2, mod_index1, mod_index2, amp |
    var fm = SinOsc.ar(car_freq +
        (SinOsc.ar(car_freq*mod_ratio1 +
            (SinOsc.ar(car_freq*mod_ratio2) * mod_index2)) * mod_index1));
    var env = EnvGen.kr(Env.linen, doneAction: 2);
    Out.ar(0, fm*env);
}).add;
)
(
x = Synth.new(\FM3OP, [\car_freq, 200,
                \mod_ratio1, 2, \mod_index1, 300,
                \mod_ratio2, 0.5, \mod_index2, 200]);
)
// 4 Oscillators

SynthDef(\FM4OP, { |car_freq, mod_ratio1, mod_ratio2, mod_ratio3, mod_index1, mod_index2, mod_index3 amp |
    var fm = SinOsc.ar(car_freq +
        (SinOsc.ar(car_freq*mod_ratio1 +
            (SinOsc.ar(car_freq*mod_ratio2 +
                (SinOsc.ar(car_freq*mod_ratio3) * mod_index3)) * mod_index2)) * mod_index1));
    var env = EnvGen.kr(Env.linen, doneAction: 2);
    Out.ar(0, fm*env);
}).add;

x = Synth.new(\FM4OP, [\car_freq, 200,
                \mod_ratio1, 2, \mod_index1, 500,
                \mod_ratio2, 0.5, \mod_index2, 200,
                \mod_ratio3, 3, \mod_index3, 700]);