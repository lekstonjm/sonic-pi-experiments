s.boot;
s.reboot;
t = TempoClock.new(80/60);

(
t.schedAbs(t.beats.ceil, {
	postf("beat:% bar:%\n",t.beats.ceil % t.beatsPerBar + 1,t.bar);
	1;
});
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
Pbindef(\a
	,\instrument,\sin
	,\freq, Pseq(#[330,440,110], inf)
	,\amp , 0.8
).play(t);
)

(
Pbindef(\b ,
	\instrument,\sin,
    \scale, #[0, 2, 3, 5, 7, 8, 10],
    \root, 3,
    \degree, Place([#[rest, 3, 2, 1, 0, -0.9, 0, 1, 2, -3, -1.9, -0.9, 0, -0.9, 0, 1, 2, 11, 10, 9, 8, 7, 8, 9, 10, 5, 6, 7, 8, 7, 8, 9, 10, 11],
        (4 ! 16) ++ \rest], inf),
	\dur, 0.25*Pwhite(0.8,1.2,inf),
	\amp , Pwhite(0.7,0.9,inf),
	\pan, Pwhite(-0.8,0.8,inf)
).play(t);
)

(
SynthDef(\help_SPE2, { arg i_out=0, sustain=1, freq=440;
	var out;
	out = RLPF.ar(
		LFSaw.ar( freq ),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	) * EnvGen.kr( Env.perc, levelScale: 0.3,
		timeScale: sustain, doneAction: 2 );
	//out = [out, DelayN.ar(out, 0.04, 0.04) ];
	5.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
	Out.ar( i_out, out );
}).add;
)
t.tempo_(180/60);
(
Pbindef(\a
	,\instrument,\help_SPE2
	,\freq, Pseq(#[24,31,36,43,48,55],inf).midicps
	,\amp , 0.8
).play(t);
)
(
Pbindef(\b
	,\instrument,\help_SPE2
    ,\scale, #[0, 2, 3, 5, 7, 8, 10]
    ,\root, 3
	,\degree, Prand([1,2,3,4],inf).midicps
	,\amp , 0.8
).play(t);
)

(
// streams as a sequence of pitches
    var pattern, streams, dur, durDiff;
    dur = 1/7;
    durDiff = 3;
    pattern = Prout.new({
        loop({
            if (0.5.coin, {
                #[ 24,31,36,43,48,55 ].do({ arg fifth; fifth.yield });
            });
            rrand(2,5).do({
                // varying arpeggio
                60.yield;
                #[63,65].choose.yield;
                67.yield;
                #[70,72,74].choose.yield;
            });
            // random high melody
            rrand(3,9).do({ #[74,75,77,79,81].choose.yield });
        });
    });
    streams = [
        (pattern - Pfunc.new({ #[12, 7, 7, 0].choose })).midicps.asStream,
        pattern.midicps.asStream
    ];
    Routine({
        loop({
            Synth( \help_SPE2, [ \freq, streams.at(0).next, \sustain, dur * durDiff ] );
            durDiff.do({
                Synth( \help_SPE2, [ \freq, streams.at(1).next, \sustain, dur ] );
                dur.wait;
            });
        })
    }).play
)
s.killAll;
s.quit;
s.boot;
s.reboot;
s.freeAll;
s.stopAll;
s.stopAliveThread;

p.stop;
Pbindef(\a).stop;
Pbindef(\b).stop;

t.stop;
