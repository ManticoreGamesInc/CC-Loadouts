local OBJECT = script:GetCustomProperty("Object"):WaitForObject()
local RANDOM_ROTATION_MIN = script:GetCustomProperty("RandomRotationMin")
local RANDOM_ROTATION_MAX = script:GetCustomProperty("RandomRotationMax")
local LOCAL = script:GetCustomProperty("Local")

-- <float> RandomFloat(number, number)
-- Returns a random float value between the bounds
function RandomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

local x = RandomFloat(RANDOM_ROTATION_MIN.x, RANDOM_ROTATION_MAX.x)
local y = RandomFloat(RANDOM_ROTATION_MIN.y, RANDOM_ROTATION_MAX.y)
local z = RandomFloat(RANDOM_ROTATION_MIN.z, RANDOM_ROTATION_MAX.z)

local newRot = Rotation.New(x, y, z)

if LOCAL then
    OBJECT:SetRotation(newRot)
else
    OBJECT:SetWorldRotation(newRot)
end