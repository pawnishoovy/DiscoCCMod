DiscoHarryVO = {}

function DiscoHarryVO.Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

DiscoHarryVO.skillIndexes = {};
DiscoHarryVO.skillIndexes["Logic"] = 1
DiscoHarryVO.skillIndexes["Encyclopedia"] = 2
DiscoHarryVO.skillIndexes["Rhetoric"] = 3
DiscoHarryVO.skillIndexes["Drama"] = 4
DiscoHarryVO.skillIndexes["Conceptualization"] = 5
DiscoHarryVO.skillIndexes["Visual Calculus"] = 6

DiscoHarryVO.skillIndexes["Volition"] = 7
DiscoHarryVO.skillIndexes["Inland Empire"] = 8
DiscoHarryVO.skillIndexes["Empathy"] = 9
DiscoHarryVO.skillIndexes["Authority"] = 10
DiscoHarryVO.skillIndexes["Esprit De Corps"] = 11
DiscoHarryVO.skillIndexes["Suggestion"] = 12

DiscoHarryVO.skillIndexes["Endurance"] = 13
DiscoHarryVO.skillIndexes["Pain Threshold"] = 14
DiscoHarryVO.skillIndexes["Physical Instrument"] = 15
DiscoHarryVO.skillIndexes["Electrochemistry"] = 16
DiscoHarryVO.skillIndexes["Shivers"] = 17
DiscoHarryVO.skillIndexes["Half-light"] = 18

DiscoHarryVO.skillIndexes["Hand/Eye Coordination"] = 19
DiscoHarryVO.skillIndexes["Perception"] = 20
DiscoHarryVO.skillIndexes["Reaction Speed"] = 21
DiscoHarryVO.skillIndexes["Savoir-Faire"] = 22
DiscoHarryVO.skillIndexes["Interfacing"] = 23
DiscoHarryVO.skillIndexes["Composure"] = 24

DiscoHarryVO.skillIndexes["Ancient Reptilian Brain"] = 25
DiscoHarryVO.skillIndexes["Limbic System"] = 26

DiscoHarryVO.transcriptions = {}

DiscoHarryVO.transcriptions["Death"] = {};
DiscoHarryVO.transcriptions["Death"][1] = {"Endurance", "This isn't a real heart attack. You should probably just exercise more."}
DiscoHarryVO.transcriptions["Death"][2] = {"Pain Threshold", "Nice try. The tears come streaming down your face as you crumble to the ground."}
DiscoHarryVO.transcriptions["Death"][3] = {"Endurance", "Feeling nausea? Vomiting? Tenderness or pain around the liver area? Tiny red lines on the skin above waist-level? The clock is ticking."}
DiscoHarryVO.transcriptions["Death"][4] = {"Half-light", "Very, very bad. This is the *end*, bad."}
DiscoHarryVO.transcriptions["Death"][5] = {"Pain Threshold", "Nope. Sorry. You don't. Not this time."}
DiscoHarryVO.transcriptions["Death"][6] = {"Endurance", "Don't think this is a sign of anything other than your heart failing."}
DiscoHarryVO.transcriptions["Death"][7] = {"Pain Threshold", "Yeah, screaming isn't happening on account of extreme shortness of breath. You're just making it worse. Oh, God, it's painful."}
DiscoHarryVO.transcriptions["Death"][8] = {"Volition", "All you feel is pain and weakness. You have to surrender now. We all do. It gets *so* dark. You don't even see her face, like you always thought you would. You only see pain, and fear."}
DiscoHarryVO.transcriptions["Death"][9] = {"Physical Instrument", "You feel something in your chest. An unnatural pressure. It's spreading to your left arm, your jaw."}
DiscoHarryVO.transcriptions["Death"][10] = {"Volition", "There's no shame in surrendering now. We all do. It gets *so* dark. You only see pain and fear."}
DiscoHarryVO.transcriptions["Death"][11] = {"Half-light", "Abort, abort! No, shit, it's too late."}
DiscoHarryVO.transcriptions["Death"][12] = {"Half-light", "Fucking shit, I'm *scared*. What do I do? Who do I call?"}
DiscoHarryVO.transcriptions["Death"][13] = {"Half-light", "Here it comes. Death."}
DiscoHarryVO.transcriptions["Death"][14] = {"Half-light", "There's no way. You're just going to die. Just close your eyes when it happens."}
DiscoHarryVO.transcriptions["Death"][15] = {"Pain Threshold", "The pain is too immense to scream. It pushes the air out of your lungs. Everything goes dark, a distant blur as you recede into it."}
DiscoHarryVO.transcriptions["Death"][16] = {"Pain Threshold", "Nothing. A persisting darkness. Dancing lights of pain, distant shadows cast by them, like a hellish play..."}
DiscoHarryVO.transcriptions["Death"][17] = {"Pain Threshold", "Something inside your pelvis *explodes*. Your entire lower body is on fire, and your legs can't support you. You fall down like a ragdoll."}
DiscoHarryVO.transcriptions["Death"][18] = {"Interfacing", "Warm blood pools underneath you. It's sticky, and there's so much of it..."}

DiscoHarryVO.transcriptions["Gib Death"] = {};
DiscoHarryVO.transcriptions["Gib Death"][1] = {"Ancient Reptilian Brain", "This is death. One more door, baby! One more door!"}
DiscoHarryVO.transcriptions["Gib Death"][2] = {"Ancient Reptilian Brain", "There is nothing. Only warm primordial blackness. Your conscious ferments in it, no larger than a single grain of malt. You don't have to do anything anymore."}
DiscoHarryVO.transcriptions["Gib Death"][3] = {"Ancient Reptilian Brain", "Alright, Nothingtown to Fuck-All-Borough!"}
DiscoHarryVO.transcriptions["Gib Death"][4] = {"Ancient Reptilian Brain", "I was wrong to let you go. I should've kept you here. Is it bright where you are? Is it *terrifying*? Have you felt *the love*?"}
DiscoHarryVO.transcriptions["Gib Death"][5] = {"Ancient Reptilian Brain", "You are *way* cool. Cooler than the bottom of the sea. Too cool for this world..."}
DiscoHarryVO.transcriptions["Gib Death"][6] = {"Ancient Reptilian Brain", "This respite... you've earned it, brother. Bask in the darkness. Let it swallow you up, and swivel you around, while you forget *everything* you've managed to remember."}
DiscoHarryVO.transcriptions["Gib Death"][7] = {"Ancient Reptilian Brain", "There are no days here. There are no weeks. Just black tape spinning, on repeat, until the end."}
DiscoHarryVO.transcriptions["Gib Death"][8] = {"Ancient Reptilian Brain", "Blackness, blackness, blackness! The ultimate disco! The ruins of your life behind you, still smoldering. Ashes rise, but you're not looking."}
DiscoHarryVO.transcriptions["Gib Death"][9] = {"Limbic System", "The fight? There is no fight. The fight is over. It was lost a thousand years ago. You have laid here forever. Keep falling... deeper... take the door."}
DiscoHarryVO.transcriptions["Gib Death"][10] = {"Limbic System", "Kim? There is no Kim. There is no fight. It's over."}
DiscoHarryVO.transcriptions["Gib Death"][11] = {"Limbic System", "You wouldn't like it if I told you what was back there. Why do you think you had to bludgeon yourDiscoHarryVO into oblivion? Or did you not sense yourDiscoHarryVO marinating? Poured so much on yourDiscoHarryVO, got a bit carried away, did we chef?"}
DiscoHarryVO.transcriptions["Gib Death"][12] = {"Limbic System", "You lost."}

DiscoHarryVO.transcriptions["Pain Light"] = {};
DiscoHarryVO.transcriptions["Pain Light"][1] = {"Pain Threshold", "There it is again, like a swarm of hornets buzzing under your skull. A strange tingling you can almost smell."}
DiscoHarryVO.transcriptions["Pain Light"][2] = {"Pain Threshold", "The pain, it is nothing. Revel in it. Absorb it. Gain power from it."}
DiscoHarryVO.transcriptions["Pain Light"][3] = {"Pain Threshold", "Oh, whatever. This barely registers as damage."}
DiscoHarryVO.transcriptions["Pain Light"][4] = {"Physical Instrument", "Even under the increased force on your skull, there is no pain. Just the sound of your own blood gushing in there, feeding your mind with oxygen."}
DiscoHarryVO.transcriptions["Pain Light"][5] = {"Pain Threshold", "A little pain there. A prick."}
DiscoHarryVO.transcriptions["Pain Light"][6] = {"Pain Threshold", "This kind of stuff would hurt, if not for you not caring about little things like that."}
DiscoHarryVO.transcriptions["Pain Light"][7] = {"Half-light", "Feels good for some reason."}
DiscoHarryVO.transcriptions["Pain Light"][8] = {"Pain Threshold", "The pain is barely noticeable under the adrenaline rush."}

DiscoHarryVO.transcriptions["Pain Medium"] = {};
DiscoHarryVO.transcriptions["Pain Medium"][1] = {"Volition", "Not again. Take the pain, God-damnit. At least take that."}
DiscoHarryVO.transcriptions["Pain Medium"][2] = {"Pain Threshold", "Sharp pain shoots through your hip, throbbing."}
DiscoHarryVO.transcriptions["Pain Medium"][3] = {"Pain Threshold", "You can take this. Blossom like a pain flower."}
DiscoHarryVO.transcriptions["Pain Medium"][4] = {"Endurance", "A small agony. Miniscule bones may have fractured."}
DiscoHarryVO.transcriptions["Pain Medium"][5] = {"Pain Threshold", "A flash of pain interrupts your thought, making you grimace."}
DiscoHarryVO.transcriptions["Pain Medium"][6] = {"Pain Threshold", "A flash of pain interrupts you, making you grimace instead of spewing out the words."}
DiscoHarryVO.transcriptions["Pain Medium"][7] = {"Pain Threshold", "A dull pain flashes through your mind."}
DiscoHarryVO.transcriptions["Pain Medium"][8] = {"Pain Threshold", "Ouch."}
DiscoHarryVO.transcriptions["Pain Medium"][9] = {"Pain Threshold", "Powered by pain."}
DiscoHarryVO.transcriptions["Pain Medium"][10] = {"Pain Threshold", "Little black spots dance on your retinas. It's almost pleasurable."}
DiscoHarryVO.transcriptions["Pain Medium"][11] = {"Pain Threshold", "You can take it. Just breathe in slowly."}
DiscoHarryVO.transcriptions["Pain Medium"][12] = {"Pain Threshold", "You can take this one too. Just breathe in slowly."}
DiscoHarryVO.transcriptions["Pain Medium"][13] = {"Pain Threshold", "You can take it. Just breathe."}
DiscoHarryVO.transcriptions["Pain Medium"][14] = {"Pain Threshold", "You can take this. It's not nearly as bad as the last time."}
DiscoHarryVO.transcriptions["Pain Medium"][15] = {"Volition", "It hurts, but keep your cool, you've got this."}
DiscoHarryVO.transcriptions["Pain Medium"][16] = {"Pain Threshold", "A bitter cringe. It *hurts*."}
DiscoHarryVO.transcriptions["Pain Medium"][17] = {"Volition", "Keep it in now. Don't over-react. Breathe."}

DiscoHarryVO.transcriptions["Pain Strong"] = {};
DiscoHarryVO.transcriptions["Pain Strong"][1] = {"Volition", "Test your limits. Surpass them. Dance 'til you drop. Dance 'til you die, if you must."}
DiscoHarryVO.transcriptions["Pain Strong"][2] = {"Pain Threshold", "I'm sorry, this didn't do anything. Usually hurting yourself does something for you."}
DiscoHarryVO.transcriptions["Pain Strong"][3] = {"Pain Threshold", "It would make a million years of evolution, or a total reversal in the condition of the world, for your pain to end."}
DiscoHarryVO.transcriptions["Pain Strong"][4] = {"Pain Threshold", "Feels like someone set a mustard field ablaze, right inside your nose, then drenched it in tear-gas. Your nose is a singular source of pain, but at the same time you don't remember the last time you felt so alive."}
DiscoHarryVO.transcriptions["Pain Strong"][5] = {"Pain Threshold", "Almost snapped your neck, but I fucking got this. No pain. No pain."}
DiscoHarryVO.transcriptions["Pain Strong"][6] = {"Pain Threshold", "Agonizing pain.	"}
DiscoHarryVO.transcriptions["Pain Strong"][7] = {"Pain Threshold", "This is bad. Feels like sharp stones grinding in your chest, and keeping you from moving."}
DiscoHarryVO.transcriptions["Pain Strong"][8] = {"Pain Threshold", "A sharp pain shoots up your side and into your stomach. You must not look too good. Luckily, it passes."}
DiscoHarryVO.transcriptions["Pain Strong"][9] = {"Pain Threshold", "A flash of pain, like slamming your fist against iron."}
DiscoHarryVO.transcriptions["Pain Strong"][10] = {"Pain Threshold", "The pain is so bad."}
DiscoHarryVO.transcriptions["Pain Strong"][11] = {"Pain Threshold", "You can take it. Just don't lean on that leg of yours too heavily."}
DiscoHarryVO.transcriptions["Pain Strong"][12] = {"Endurance", "The pain flows over your entire body like an awful shock. A grim knowing rises from within. Half of your body must be *gone*."}
DiscoHarryVO.transcriptions["Pain Strong"][13] = {"Endurance", "Feels slick and warm with blood. The pain is too strong to know what has happened there. Even clutching to your consciousness takes everything you've got."}
DiscoHarryVO.transcriptions["Pain Strong"][14] = {"Pain Threshold", "Get ready for a world pain, man..."}
DiscoHarryVO.transcriptions["Pain Strong"][15] = {"Endurance", "It's too much. You can feel your vertebrae starting to crack, your muscles groaning..."}
DiscoHarryVO.transcriptions["Pain Strong"][16] = {"Pain Threshold", "A volcano of burning pain erupts from your left shoulder."}

DiscoHarryVO.transcriptions["Recover"] = {};
DiscoHarryVO.transcriptions["Recover"][1] = {"Pain Threshold", "Finally, the stabbing recedes. You could try doing it again to see how painful it gets - very. But, do you really want to risk it?"}
DiscoHarryVO.transcriptions["Recover"][2] = {"Endurance", "Finally, the pressure recedes. You find yourDiscoHarryVO covered in cold sweat. Try not to move too fast. Maybe that will keep you from collapsing."}
DiscoHarryVO.transcriptions["Recover"][3] = {"Physical Instrument", "You feel the pain recede. You just need to get up and dust yourDiscoHarryVO off."}
DiscoHarryVO.transcriptions["Recover"][4] = {"Volition", "It's nothing. You're alive, that's what matters."}
DiscoHarryVO.transcriptions["Recover"][5] = {"Volition", "No you don't. You can keep it in. You can keep *anything* in."}
DiscoHarryVO.transcriptions["Recover"][6] = {"Half-light", "Yes, bullets will fly. They always do. And the coil is fleshy and mush and permeable. Resist death."}
DiscoHarryVO.transcriptions["Recover"][7] = {"Physical Instrument", "Things are not as bad as they look. Sure, you have high blood pressure from metabolizing heroic quantities of ethanol, but you are robustly built. You will survive."}
DiscoHarryVO.transcriptions["Recover"][8] = {"Physical Instrument", "You hear your heart pumping, fast and irregular. Your joints ache and you feel *old*... but still alive, somehow."}
DiscoHarryVO.transcriptions["Recover"][9] = {"Endurance", "Merely standing up makes you sweat profusely. Your breathing is erratic. Your own heartbeat in your ears grows frantic, and you feel your blood pressure rise."}
DiscoHarryVO.transcriptions["Recover"][10] = {"Pain Threshold", "Maybe don't beat yourDiscoHarryVO anymore, though. You're not immortal."}
DiscoHarryVO.transcriptions["Recover"][11] = {"Pain Threshold", "Phew. Got off lucky there. That could've resulted in a world of hurt."}
DiscoHarryVO.transcriptions["Recover"][12] = {"Volition", "Get it together, boy. You've got to hold on. No matter how bad."}

DiscoHarryVO.transcriptions["Spot"] = {};
DiscoHarryVO.transcriptions["Spot"][1] = {"Half-light", "He's open. Rip into him. Right hook, escalate it. Get *intimate* with him. Bring the hurt closer."}
DiscoHarryVO.transcriptions["Spot"][2] = {"Half-light", "Rip into him. Right hook. Get *intimate* with him. Bring the hurt closer."}
DiscoHarryVO.transcriptions["Spot"][3] = {"Half-light", "Do it. NOW."}
DiscoHarryVO.transcriptions["Spot"][4] = {"Half-light", "This is your chance. Rip into him with a punch and catch him off-guard."}
DiscoHarryVO.transcriptions["Spot"][5] = {"Half-light", "Time for a threat."}
DiscoHarryVO.transcriptions["Spot"][6] = {"Half-light", "There the grandness, there is fear."}
DiscoHarryVO.transcriptions["Spot"][7] = {"Authority", "Men like this only respect two things. Strength, and fear."}
DiscoHarryVO.transcriptions["Spot"][8] = {"Volition", "Never forget. The whole world's a wooden house, and you're a God-damn flamethrower."}
DiscoHarryVO.transcriptions["Spot"][9] = {"Authority", "You're a *god*. An angry, but just god."}
DiscoHarryVO.transcriptions["Spot"][10] = {"Authority", "People try to back away from you, or even slip out of the door. But you screamed, 'I am the God-damned *law*, and you have to listen to me. You are all suspects in a murder investigation.'"}
DiscoHarryVO.transcriptions["Spot"][11] = {"Half-light", "He's about to open fire."}
DiscoHarryVO.transcriptions["Spot"][12] = {"Half-light", "He's about to snap and shoot someone *right now*."}
DiscoHarryVO.transcriptions["Spot"][13] = {"Half-light", "Whatever you do, stop wasting your time thinking about it."}
DiscoHarryVO.transcriptions["Spot"][14] = {"Authority", "He's not afraid of jail. He's afraid of something else."}
DiscoHarryVO.transcriptions["Spot"][15] = {"Reaction Speed", "You feel your legs shaking under you, and your gun hand move to your holster. To grab the gun."}
DiscoHarryVO.transcriptions["Spot"][16] = {"Half-light", "Tear into him. Pile it on him. Everything you got on him. The more the better."}
DiscoHarryVO.transcriptions["Spot"][17] = {"Half-light", "A spasm of rage, sudden and uncontrollable."}
DiscoHarryVO.transcriptions["Spot"][18] = {"Half-light", "The danger levels here are hard to read."}
DiscoHarryVO.transcriptions["Spot"][19] = {"Half-light", "They're *afraid*. All of them. Trembling reads in the wind. They'll run, scatter soon, one by one."}
DiscoHarryVO.transcriptions["Spot"][20] = {"Half-light", "He's gonna do it. He's gonna shoot."}
DiscoHarryVO.transcriptions["Spot"][21] = {"Reaction Speed", "Now. Now is the time. Stop waiting."}
DiscoHarryVO.transcriptions["Spot"][22] = {"Hand/Eye Coordination", "Your muscles tense up. The vision in your dead angle darkens."}
DiscoHarryVO.transcriptions["Spot"][23] = {"Half-light", "Shoot him in the mouth. Shoot him before he shoots you."}
DiscoHarryVO.transcriptions["Spot"][24] = {"Half-light", "Around you, time starts moving again. The sounds of violence, and panic."}
DiscoHarryVO.transcriptions["Spot"][25] = {"Reaction Speed", "Oh God, watch out!"}
DiscoHarryVO.transcriptions["Spot"][26] = {"Half-light", "Just like that, instinct took over."}
DiscoHarryVO.transcriptions["Spot"][27] = {"Half-light", "Now fire. Fuck them up. Do it. The muscles on your back tense up."}
DiscoHarryVO.transcriptions["Spot"][28] = {"Reaction Speed", "It's as time has frozen somehow. Yeah, this is going to be *way* cool."}
DiscoHarryVO.transcriptions["Spot"][29] = {"Half-light", "Blam! Straight in the eye. Straight in the ol' eye-orb. In, the *looking ball*."}
DiscoHarryVO.transcriptions["Spot"][30] = {"Half-light", "This man looks like trouble. You might not want to get into this right now. Plenty of time later..."}
DiscoHarryVO.transcriptions["Spot"][31] = {"Reaction Speed", "His fingers are twitching. That's a draw reflex. He's about to draw."}
DiscoHarryVO.transcriptions["Spot"][32] = {"Volition", "Easy. Easy now."}

DiscoHarryVO.transcriptions["Gun Aim"] = {};
DiscoHarryVO.transcriptions["Gun Aim"][1] = {"Hand/Eye Coordination", "Hand on the hair-trigger, on a calm day like this..."}
DiscoHarryVO.transcriptions["Gun Aim"][2] = {"Hand/Eye Coordination", "You stand with your feet planted firmly on the ground, and your left hand supporting your gun-arm."}
DiscoHarryVO.transcriptions["Gun Aim"][3] = {"Hand/Eye Coordination", "Your field of view narrows."}
DiscoHarryVO.transcriptions["Gun Aim"][4] = {"Interfacing", "Holding the gun feels natural and satisfying. It's like an extension of your arm, the polished wooden handle almost fusing into your palm."}
DiscoHarryVO.transcriptions["Gun Aim"][5] = {"Interfacing", "It reminds you of the day you first held it, with fear and respect, hoping you don't have to use it in vain. The sun was out in Jamrock, it was so long ago."}
DiscoHarryVO.transcriptions["Gun Aim"][6] = {"Half-Light", "This gun, Sunrise Parabellum, will be the only thing standing between you and the all-consuming nothingness that threatens to eat the world."}
DiscoHarryVO.transcriptions["Gun Aim"][7] = {"Authority", "A Villiers 9mm pistol, where Insulindian steel meets Revachol craftsmanship. With it, thou wilt protect the fair people of thine homeland, and keep the visitors *at check*."}
DiscoHarryVO.transcriptions["Gun Aim"][8] = {"Inland Empire", "This is your gun. Now if we could only find your personality..."}
DiscoHarryVO.transcriptions["Gun Aim"][9] = {"Savoir-Faire", "This is your gun, and in the world of unarmed civilians, a man with a gun is king, but in a wholesome and life-affirming way. You just keep the wheels of the world spinning, and maybe there's some money to be made on the side."}
DiscoHarryVO.transcriptions["Gun Aim"][10] = {"Conceptualization", "The gun - your gun - can be an item of destruction, but also creation. The Villiers-LaSalle art project. Time to shoot some beauty into the heart of Martinaise"}
DiscoHarryVO.transcriptions["Gun Aim"][11] = {"Endurance", "Although only useful against assailants made of flesh and blood, the gun is still yours."}
DiscoHarryVO.transcriptions["Gun Aim"][12] = {"Reaction Speed", "At last. The fastest hand in Revachol reunited with the slickest tool in the North. You're gonna be the envy of the town, baby."}
DiscoHarryVO.transcriptions["Gun Aim"][13] = {"Interfacing", "Your hand twitches. It feels familiar, doesn't it?"}
DiscoHarryVO.transcriptions["Gun Aim"][14] = {"Reaction Speed", "0.4 seconds remain."}
DiscoHarryVO.transcriptions["Gun Aim"][15] = {"Reaction Speed", "0.6 seconds remain."}	

DiscoHarryVO.transcriptions["Gun Shoot"] = {};
DiscoHarryVO.transcriptions["Gun Shoot"][1] = {"Interfacing", "A plume of smoke and fire erupts from the gun, and your hand goes numb from the explosion."}
DiscoHarryVO.transcriptions["Gun Shoot"][2] = {"Interfacing", "Another soft explosion, like a firecracker, goes off in your hand."}
DiscoHarryVO.transcriptions["Gun Shoot"][3] = {"Perception", "You hear an explosion within the weapon in your hands. Your ears are still ringing."}
DiscoHarryVO.transcriptions["Gun Shoot"][4] = {"Interfacing", "A plume of smoke erupts from the barrel. Your hand goes numb from the explosion. With your ears still ringing, you lower the weapon to see what happened."}
DiscoHarryVO.transcriptions["Gun Shoot"][5] = {"Interfacing", "The cold piece of gun metal is surprisingly light. Your fingers fit right through the guard, instinctively resting on the trigger."}

DiscoHarryVO.transcriptions["Head Hit"] = {};
DiscoHarryVO.transcriptions["Head Hit"][1] = {"Hand/Eye Coordination", "This time feels different. You aim higher, as if pulled by a magnet. Your hand goes numb from the explosion, and a plume of smoke erupts from the gun."}
DiscoHarryVO.transcriptions["Head Hit"][2] = {"Hand/Eye Coordination", "You know, you don't feel like too bad a of shot yourDiscoHarryVO..."}	

DiscoHarryVO.transcriptions["Hit"] = {};
DiscoHarryVO.transcriptions["Hit"][1] = {"Authority", "With your hand numb from the recoil, you look at the body slumped down. For a moment, the man appears to *kneel* in front of you."}	

DiscoHarryVO.transcriptions["Partial Miss"] = {};
DiscoHarryVO.transcriptions["Partial Miss"][1] = {"Hand/Eye Coordination", "A small explosion expels the bullet from the chamber. With a puff of smoke it hits the man square in the chest."}	

DiscoHarryVO.transcriptions["Total Miss"] = {};
DiscoHarryVO.transcriptions["Total Miss"][1] = {"Hand/Eye Coordination", "No. It's off. *Way* off."}		
DiscoHarryVO.transcriptions["Total Miss"][2] = {"Hand/Eye Coordination", "A lot of things were wrong with that shot."}