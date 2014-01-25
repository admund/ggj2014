
local class = {}

class.thankYouSample = audio.loadSound("sfx/thank_you_s.wav")

function class.playThankYou()
    audio.play(class.thankYouSample)
end

return class
