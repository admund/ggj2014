
local class = {}

class.manThankYou = audio.loadSound("sfx/man_thank_you.wav")
class.grannyThankYou = audio.loadSound("sfx/granny_thank_you.wav")
class.auc = audio.loadSound("sfx/auc.wav")
class.good = audio.loadSound("sfx/good.wav")
class.ironman = audio.loadSound("sfx/ironman.wav")
class.loose = audio.loadSound("sfx/loose.wav")
class.money = audio.loadSound("sfx/money.wav")
class.noMoney = audio.loadSound("sfx/no_money.wav")
class.slow = audio.loadSound("sfx/slow.wav")
class.speedUp = audio.loadSound("sfx/speed_up.wav")
class.weak = audio.loadSound("sfx/weak.wav")

function class.playManThankYou()
    audio.play(class.manThankYou)
end

function class.playGrannyThankYou()
    audio.play(class.grannyThankYou)
end

function class.playAuc()
    audio.play(class.auc)
end

function class.playGood()
    audio.play(class.good)
end

function class.playIronman()
    audio.play(class.ironman)
end

function class.playLoose()
    audio.play(class.loose)
end

function class.playMoney()
    audio.play(class.money)
end

function class.playNoMoney()
    audio.play(class.noMoney)
end

function class.playSlow()
    audio.play(class.slow)
end

function class.playSpeedUp()
    audio.play(class.speedUp)
end

function class.playWeak()
    audio.play(class.weak)
end


return class
