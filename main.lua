local json = require("json")
local mod = RegisterMod("Tainted Items", 1)

mod.Init = false

function mod:InitSaveData()
  mod.Data = {} 
end
mod:InitSaveData()

local sfx = SFXManager()
local game = Game()
local rng = RNG()

mod.COLLECTIBLE_SAD_ONION = Isaac.GetItemIdByName("The Sad Onion?")
mod.COLLECTIBLE_BODY = Isaac.GetItemIdByName("The Body?")
mod.COLLECTIBLE_LEMON_MISHAP = Isaac.GetItemIdByName("Lemon Mishap?")
mod.COLLECTIBLE_D6 = Isaac.GetItemIdByName("The D6?")
mod.COLLECTIBLE_SPINDOWN_DICE = Isaac.GetItemIdByName("Spindown Dice?")
mod.COLLECTIBLE_CHOCOLATE_MILK = Isaac.GetItemIdByName("Chocolate Milk?")
mod.COLLECTIBLE_POLYPHEMUS = Isaac.GetItemIdByName("Polyphemus?")
mod.COLLECTIBLE_ROTTEN_MEAT = Isaac.GetItemIdByName("Rotten Meat?")
mod.COLLECTIBLE_DEAD_CAT = Isaac.GetItemIdByName("Dead Cat?")
mod.COLLECTIBLE_BOOK_OF_SIN = Isaac.GetItemIdByName("The Book of Sin?")
mod.COLLECTIBLE_CHEMICAL_PEEL = Isaac.GetItemIdByName("Chemical Peel?")
mod.COLLECTIBLE_IPECAC = Isaac.GetItemIdByName("Ipecac?")
mod.COLLECTIBLE_SMB_SUPER_FAN = Isaac.GetItemIdByName("SMB Super Fan?")
mod.COLLECTIBLE_1UP = Isaac.GetItemIdByName("1up?")
mod.COLLECTIBLE_MAGIC_MUSHROOM = Isaac.GetItemIdByName("Magic Mushroom?")
mod.COLLECTIBLE_D20 = Isaac.GetItemIdByName("D20?")

if not __eidItemDescriptions then
    __eidItemDescriptions = {}
end

__eidItemDescriptions[mod.COLLECTIBLE_SAD_ONION] = "+1.56 tears up#You can no longer fire tears manually (blindfold effect)#Tears are automatically emitted in a random spread"
__eidItemDescriptions[mod.COLLECTIBLE_BODY] = "+5 heart containers#Empties all but 1 red heart container#Your speed increases proportionally to the amount of empty heart containers you have"
__eidItemDescriptions[mod.COLLECTIBLE_LEMON_MISHAP] = "Temporary Number One effect (tears up, range down)#Tears leave yellow creep on impact"
__eidItemDescriptions[mod.COLLECTIBLE_D6] = "[Not done]"
__eidItemDescriptions[mod.COLLECTIBLE_SPINDOWN_DICE] = "Converts an item to its tainted version, and vice-versa#If an item does not have a tainted version, rerolls into a random tainted item"
__eidItemDescriptions[mod.COLLECTIBLE_CHOCOLATE_MILK] = "+1 heart container#+1 empty bone heart#Heals you for 1 red heart"
__eidItemDescriptions[mod.COLLECTIBLE_POLYPHEMUS] = "[Not done]"
__eidItemDescriptions[mod.COLLECTIBLE_ROTTEN_MEAT] = "+1 empty heart container#Every red heart you have is converted to a rotten heart"
__eidItemDescriptions[mod.COLLECTIBLE_DEAD_CAT] = "Instantly gives you the Guppy transformation#Sets your health to 1 soul heart"
__eidItemDescriptions[mod.COLLECTIBLE_BOOK_OF_SIN] = "Spawns a random Sin miniboss#Closes all doors in the room, if possible#The Sin will drop its usual items and re-open the doors on death"
__eidItemDescriptions[mod.COLLECTIBLE_CHEMICAL_PEEL] = "+0.6 damage up#You trail red creep, which scales with your damage"
__eidItemDescriptions[mod.COLLECTIBLE_IPECAC] = "0.33x tears down#4x damage up#Tears arc above the ground#Tears leave a puddle of green creep, which scales with your damage#Tears and creep apply poison to enemies"
__eidItemDescriptions[mod.COLLECTIBLE_SMB_SUPER_FAN] = "+99 extra lives#+0.8 speed up#2x damage up#You lose all health, except for a half soul heart#HP ups no longer work#On death, you revive in the room you're in, and all enemies/hazards respawn"
__eidItemDescriptions[mod.COLLECTIBLE_1UP] = "[Not done]"
__eidItemDescriptions[mod.COLLECTIBLE_MAGIC_MUSHROOM] = "While 'powered up':#+0.3 damage up#2.3x damage up#+0.3 speed up#Size up#If you get hit, you lose the 'power up' for the rest of the floor"
__eidItemDescriptions[mod.COLLECTIBLE_D20] = "Converts a pickup to its 'opposite', if possible#Examples:#Red Heart = Soul Heart#Bomb = Key#Coin = Troll Bomb"

mod.TaintedItemPool = {
  mod.COLLECTIBLE_SAD_ONION,
  mod.COLLECTIBLE_BODY,
  mod.COLLECTIBLE_LEMON_MISHAP,
  --mod.COLLECTIBLE_D6,
  mod.COLLECTIBLE_SPINDOWN_DICE,
  mod.COLLECTIBLE_CHOCOLATE_MILK,
  --mod.COLLECTIBLE_POLYPHEMUS,
  mod.COLLECTIBLE_ROTTEN_MEAT,
  mod.COLLECTIBLE_DEAD_CAT,
  mod.COLLECTIBLE_BOOK_OF_SIN,
  mod.COLLECTIBLE_CHEMICAL_PEEL,
  mod.COLLECTIBLE_IPECAC,
  mod.COLLECTIBLE_SMB_SUPER_FAN,
  --mod.COLLECTIBLE_1UP,
  mod.COLLECTIBLE_MAGIC_MUSHROOM,
  mod.COLLECTIBLE_D20,
}

mod.RegularToTainted = {
  [CollectibleType.COLLECTIBLE_SAD_ONION] = mod.COLLECTIBLE_SAD_ONION,
  [CollectibleType.COLLECTIBLE_BODY] = mod.COLLECTIBLE_BODY,
  [CollectibleType.COLLECTIBLE_LEMON_MISHAP] = mod.COLLECTIBLE_LEMON_MISHAP,
  --[CollectibleType.COLLECTIBLE_D6] = mod.COLLECTIBLE_D6,
  [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = mod.COLLECTIBLE_SPINDOWN_DICE,
  [CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = mod.COLLECTIBLE_CHOCOLATE_MILK,
  --[CollectibleType.COLLECTIBLE_POLYPHEMUS] = mod.COLLECTIBLE_POLYPHEMUS,
  [CollectibleType.COLLECTIBLE_ROTTEN_MEAT] = mod.COLLECTIBLE_ROTTEN_MEAT,
  [CollectibleType.COLLECTIBLE_DEAD_CAT] = mod.COLLECTIBLE_DEAD_CAT,
  [CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = mod.COLLECTIBLE_BOOK_OF_SIN,
  [CollectibleType.COLLECTIBLE_CHEMICAL_PEEL] = mod.COLLECTIBLE_CHEMICAL_PEEL,
  [CollectibleType.COLLECTIBLE_IPECAC] = mod.COLLECTIBLE_IPECAC,
  [CollectibleType.COLLECTIBLE_SMB_SUPER_FAN] = mod.COLLECTIBLE_SMB_SUPER_FAN,
  --[CollectibleType.COLLECTIBLE_1UP] = mod.COLLECTIBLE_1UP,
  [CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM] = mod.COLLECTIBLE_MAGIC_MUSHROOM,
  [CollectibleType.COLLECTIBLE_D20] = mod.COLLECTIBLE_D20,
}

mod.TaintedToRegular = {
  [mod.COLLECTIBLE_SAD_ONION] = CollectibleType.COLLECTIBLE_SAD_ONION,
  [mod.COLLECTIBLE_BODY] = CollectibleType.COLLECTIBLE_BODY,
  [mod.COLLECTIBLE_LEMON_MISHAP] = CollectibleType.COLLECTIBLE_LEMON_MISHAP,
  --[mod.COLLECTIBLE_D6] = CollectibleType.COLLECTIBLE_D6,
  [mod.COLLECTIBLE_SPINDOWN_DICE] = CollectibleType.COLLECTIBLE_SPINDOWN_DICE,
  [mod.COLLECTIBLE_CHOCOLATE_MILK] = CollectibleType.COLLECTIBLE_CHOCOLATE_MILK,
  --[mod.COLLECTIBLE_POLYPHEMUS] = CollectibleType.COLLECTIBLE_POLYPHEMUS,
  [mod.COLLECTIBLE_ROTTEN_MEAT] = CollectibleType.COLLECTIBLE_ROTTEN_MEAT,
  [mod.COLLECTIBLE_DEAD_CAT] = CollectibleType.COLLECTIBLE_DEAD_CAT,
  [mod.COLLECTIBLE_BOOK_OF_SIN] = CollectibleType.COLLECTIBLE_BOOK_OF_SIN,
  [mod.COLLECTIBLE_CHEMICAL_PEEL] = CollectibleType.COLLECTIBLE_CHEMICAL_PEEL,
  [mod.COLLECTIBLE_IPECAC] = CollectibleType.COLLECTIBLE_IPECAC,
  [mod.COLLECTIBLE_SMB_SUPER_FAN] = CollectibleType.COLLECTIBLE_SMB_SUPER_FAN,
  --[mod.COLLECTIBLE_1UP] = CollectibleType.COLLECTIBLE_1UP,
  [mod.COLLECTIBLE_MAGIC_MUSHROOM] = CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
  [mod.COLLECTIBLE_D20] = CollectibleType.COLLECTIBLE_D20,
}

mod.PICKUP_BASE_ID = 800
mod.PICKUP_TAINTED_KEY = 10

mod.TheSins = {
  EntityType.ENTITY_PRIDE,
  EntityType.ENTITY_GREED,
  EntityType.ENTITY_WRATH,
  EntityType.ENTITY_ENVY,
  EntityType.ENTITY_LUST,
  EntityType.ENTITY_GLUTTONY,
  EntityType.ENTITY_SLOTH,
  -- So put to death the sinful, earthly things lurking within you...
}

-- HELPER FUNCTIONS --
function mod:FlipPickup(id, var, sub)
  -- Yeah, this code sucks. Get over it.
  if id == 5 and var == PickupVariant.PICKUP_HEART then
    if sub == HeartSubType.HEART_FULL then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    elseif sub == HeartSubType.HEART_HALF then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL}
    elseif sub == HeartSubType.HEART_SOUL then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}
    elseif sub == HeartSubType.HEART_ETERNAL then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK}
    elseif sub == HeartSubType.HEART_DOUBLEPACK then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN}
    elseif sub == HeartSubType.HEART_BLACK then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL}
    elseif sub == HeartSubType.HEART_GOLDEN then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK}
    elseif sub == HeartSubType.HEART_HALF_SOUL then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF}
    elseif sub == HeartSubType.HEART_BONE	then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN}
    elseif sub == HeartSubType.HEART_ROTTEN then
      return {5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE}
    end
  elseif id == 5 and var == PickupVariant.PICKUP_BOMB then
    if sub == BombSubType.BOMB_NORMAL then
      return {5, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}
    end
  elseif id == 5 and var == PickupVariant.PICKUP_KEY then
    if sub == KeySubType.KEY_NORMAL then
      return {5, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
    end
  elseif id == 5 and var == PickupVariant.PICKUP_COIN then
    if sub == CoinSubType.COIN_PENNY then
      return {4, BombVariant.BOMB_TROLL, 0}
    end
  elseif id == 4 then
    if var == BombVariant.BOMB_TROLL then
      return {5, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY}
    end
  end
end

function mod:WipePlayerHealth(player)
  player:AddMaxHearts(-player:GetMaxHearts())
  player:AddSoulHearts(-player:GetSoulHearts())
  player:AddBoneHearts(-player:GetBoneHearts())
end

function mod:IsTaintedItem(id)
  return (id >= mod.TaintedItemPool[1] and id <= mod.TaintedItemPool[#mod.TaintedItemPool])
end

function mod:IsValidFloor()
  local level = game:GetLevel()
  local stage = level:GetAbsoluteStage()
  local thetype = level:GetStageType()
  -- Check for item rooms in Chapter 5
  if stage == LevelStage.STAGE5 then
    for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
      if (player:HasTrinket(TrinketType.TRINKET_WICKED_CROWN) and thetype == StageType.STAGETYPE_ORIGINAL) or (player:HasTrinket(TrinketType.TRINKET_HOLY_CROWN) and thetype == StageType.STAGETYPE_WOTL) then
        return true
      end
    end
  end
  -- Check for item rooms in Chapter 4
  if stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
    for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
      if player:HasTrinket(TrinketType.TRINKET_BLOODY_CROWN) then
        return true
      end
    end
  end
  -- Regular chapters from 1-2 to 3-2
  if stage >= LevelStage.STAGE1_2 and stage <= LevelStage.STAGE3_2 then
    return true
  end
  -- Alternate path chapter 1-1
  if stage == LevelStage.STAGE1_1 and thetype >= StageType.STAGETYPE_REPENTANCE then
    return true
  end
  -- This is a floor without a locked item room
  return false
end

function mod:UpdateKeyChance()
  if not mod.Init then return end
  if not mod:IsValidFloor() then
    mod.Data.KeyChance = 0.0
  else
    mod.Data.KeyChance = 1.0
  end
  mod.Data.KeyChance = mod.Data.KeyChance * 100
end

function mod:RollForKey()
  local room = game:GetRoom()
  rng:SetSeed(room:GetSpawnSeed(), 0)
  local number = rng:RandomInt(100)
  if number <= mod.Data.KeyChance then
    return true
  end
  return false
end

function mod:TaintItemPedestal(p)
  local data = p:GetData()
  local pos = p.Position
  local id = p.SubType
  p:Remove()
  if data.TI_IsTaintedPedestal or mod:IsTaintedItem(id) then
    local pedestal = Isaac.Spawn(5, 100, mod.TaintedToRegular[id], pos, Vector.Zero, nil)
  else
    local newID = {}
    if mod.RegularToTainted[id] ~= nil then
      newID = mod.RegularToTainted[id]
    else
      newID = mod.TaintedItemPool[math.random(1, #mod.TaintedItemPool)]
    end
    Isaac.Spawn(5, 100, newID, pos, Vector.Zero, nil)
  end
end

function mod:MushroomPowerUp(player, bool)
  if bool then
    sfx:Play(SoundEffect.SOUND_1UP, 1, 0, false, 1.0)
  else
    player:AnimateSad()
    player:GetData().TI_IsLosingPowerUp = true
  end
  player:GetData().TI_PoweredUp = bool
  player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SIZE)
  player:EvaluateItems()
end

function mod:OnItemPickup(id, player)
  local data = player:GetData()
  -- The Body
  if id == mod.COLLECTIBLE_BODY then
    player:AddHearts(-(player:GetHearts() - 2))
    data.TI_BodyMoveSpeed = player.MoveSpeed
  end
  -- Chocolate Milk
  if id == mod.COLLECTIBLE_CHOCOLATE_MILK then
    player:AddBoneHearts(1)
  end
  -- Rotten Meat
  if id == mod.COLLECTIBLE_ROTTEN_MEAT then
    local health = player:GetHearts()
    player:AddHearts(-health)
    player:AddRottenHearts(health)
    player:AddPlayerFormCostume(PlayerForm.PLAYERFORM_GUPPY)
  end
  -- Dead Cat
  if id == mod.COLLECTIBLE_DEAD_CAT then
    for i=1,2 do player:AddCollectible(mod.COLLECTIBLE_DEAD_CAT) end
    mod:WipePlayerHealth(player)
    player:AddSoulHearts(2)
  end
  -- Ipecac
  if id == mod.COLLECTIBLE_IPECAC then
    player.TearColor = Color(0.5, 0.8999, 0.4, 1, 0, 0, 0)
  end
  -- SMB Super Fan
  if id == mod.COLLECTIBLE_SMB_SUPER_FAN then
    mod:WipePlayerHealth(player)
    player:AddSoulHearts(1)
    data.TI_SMBLives = 99
  end
  -- 1up
  if id == mod.COLLECTIBLE_1UP then
    data.TI_HasConsumedLife = false
  end
  -- Magic Mushroom
  if id == mod.COLLECTIBLE_MAGIC_MUSHROOM then
    mod:MushroomPowerUp(player, true)
  end
end

function mod:QueueEmpty(player)
  local data = player:GetData()
  if (data.TI_PickedItemID ~= CollectibleType.COLLECTIBLE_NULL) then
    mod:OnItemPickup(data.TI_PickedItemID, player)
    data.TI_PickedItemID = 0
  end
end

function mod:QueueNotEmpty(player)
  local data = player:GetData()
  local queuedItem = player.QueuedItem.Item
  if queuedItem ~= nil and queuedItem.ID ~= data.TI_PickedItemID then
    data.TI_PickedItemID = queuedItem.ID
  end
end

function mod:SpawnLemonMishapCreep(player, tear)
  local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, tear.Position, Vector.Zero, player)
  local color = Color(1, 1, 1, 1, 0, 0, 0)
  color:SetColorize(8, (243/255)*8, 0, 1)
  creep:GetSprite().Color = color
end

function mod:SpawnIpecacCreep(player, tear)
  local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_GREEN, 0, tear.Position, Vector.Zero, player)
  creep.CollisionDamage = creep.CollisionDamage * (player.Damage / 4)
  creep:GetData().TI_IpecacCreep = true
  creep:ToEffect().Scale = 2
  creep:ToEffect():SetTimeout(50)
end

-- MOD CALLBACKS --
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
  for i = 1, game:GetNumPlayers() do
    local player = Isaac.GetPlayer(i - 1)
    if player:IsItemQueueEmpty() then
      mod:QueueEmpty(player)
    else
      mod:QueueNotEmpty(player)
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function(_)
  if not mod.Init then return end
  local chance = string.format("%.1s%%", "?")
  if mod.Data.KeyChance then
    chance = string.format("%.1f%%", mod.Data.KeyChance)
  else
    mod:UpdateKeyChance()
  end
  --mod.Font:DrawString(("Key Chance: " .. chance), 60, 50, KColor(1,1,1,1,0,0,0), 0, true)
  --mod.Font:DrawString(("Has Key: " .. tostring(mod.Data.HasKey)), 60, 40, KColor(1,1,1,1,0,0,0), 0, true)
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_)
  if not mod.Init then return end
  if mod.Data then
    mod:SaveData(json.encode(mod.Data))
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
  if not continued then
--    for i = 1, game:GetNumPlayers() do
--      local player = Isaac.GetPlayer(i - 1)
--      player:GetData().TI_PoweredUp = false
--    end
    mod.Data.KeyChance = nil
    mod.Data.HasKey = false
    mod:UpdateKeyChance()
  elseif (mod:HasData()) then
    mod.Data = json.decode(mod:LoadData())
  end
  mod.Font = Font()
  mod.Font:Load("font/luaminioutlined.fnt")
  mod.Init = true
end)

mod.HeadDirectionToVector = {
  [Direction.LEFT] = Vector(-1,0),
  [Direction.RIGHT] = Vector(1,0),
  [Direction.UP] = Vector(0,-1),
  [Direction.DOWN] = Vector(0,1),
}

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
  local data = player:GetData()
  -- The Sad Onion
  if player:HasCollectible(mod.COLLECTIBLE_SAD_ONION) and player.ControlsEnabled then
    player.FireDelay = player.MaxFireDelay + 10
    data.TI_FireDelay = data.TI_FireDelay or 0
    if data.TI_FireDelay > 0 then
      data.TI_FireDelay = data.TI_FireDelay - 1
    end
    if data.TI_FireDelay <= 0 then
      data.TI_FireDelay = data.TI_FireDelay + player.MaxFireDelay + 1
      player:FireTear(player.Position, player.Velocity + mod.HeadDirectionToVector[player:GetHeadDirection()]:Resized(10 * player.ShotSpeed):Rotated(math.random(-50, 50)), true, false, true, player, 1) 
    end
  end
  -- The Body
  if player:HasCollectible(mod.COLLECTIBLE_BODY) then
    if player:CanPickRedHearts() then
      if player:GetHearts() ~= data.TI_BodyHearts then
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
      end
    else
      if player:GetSoulHearts() ~= data.TI_BodyHearts then
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
      end
    end
  end
  -- Chemical Peel
  if player:HasCollectible(mod.COLLECTIBLE_CHEMICAL_PEEL) then
    if player.FrameCount % 4 == 0 then
      local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player)
      creep.CollisionDamage = creep.CollisionDamage * (player.Damage / 3.50)
    end
  end
  -- SMB Super Fan
  if player:HasCollectible(mod.COLLECTIBLE_SMB_SUPER_FAN) then
    if (player:GetHearts() + player:GetSoulHearts()) > 1 then
      mod:WipePlayerHealth(player)
      player:AddSoulHearts(1)
    end
    if player:IsDead() and player:GetSprite():IsPlaying("Death") and data.TI_SMBLives >= 1 then
      local frame = player:GetSprite():GetFrame()
      if frame == 54 then
        game:StartRoomTransition(game:GetLevel():GetCurrentRoomIndex(), -1, 1)
        player:Revive()
        data.TI_SMBLives = data.TI_SMBLives -1
      end
    end
  end
  -- 1up
  if player:HasCollectible(mod.COLLECTIBLE_1UP) then
    if player:IsDead() and player:GetSprite():IsPlaying("Death") and (data.TI_SMBLives == nil or data.TI_SMBLives <= 0) then
      local frame = player:GetSprite():GetFrame()
      if frame == 54 and not data.TI_HasConsumedLife then
        player:Revive()
        player:GetSprite():Stop()
        game:StartStageTransition(true, 1)
        data.TI_HasConsumedLife = true
      end
    end
  end
  -- Magic Mushroom
  if player:HasCollectible(mod.COLLECTIBLE_MAGIC_MUSHROOM) then
    if data.TI_IsLosingPowerUp and not player:GetSprite():IsPlaying("Sad") then
      data.TI_IsLosingPowerUp = false
    end
    if player.ControlsEnabled and data.TI_ReadyForPowerUp and not data.TI_PoweredUp then
      mod:MushroomPowerUp(player, true)
      data.TI_ReadyForPowerUp = false
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
  local data = player:GetData()
  if flag == CacheFlag.CACHE_FIREDELAY then
    -- Sad Onion, Ipecac
    player.MaxFireDelay = player.MaxFireDelay - (4 * player:GetCollectibleNum(mod.COLLECTIBLE_SAD_ONION)) + (player.MaxFireDelay * 1.66 * player:GetCollectibleNum(mod.COLLECTIBLE_IPECAC))
  end
  if flag == CacheFlag.CACHE_SPEED then
    -- SMB Super Fan, Magic Mushroom
    player.MoveSpeed = player.MoveSpeed + (0.8 * player:GetCollectibleNum(mod.COLLECTIBLE_SMB_SUPER_FAN)) + (0.3 * player:GetCollectibleNum(mod.COLLECTIBLE_MAGIC_MUSHROOM) * (data.TI_PoweredUp and 1 or 0))
    -- The Body
    if player:HasCollectible(mod.COLLECTIBLE_BODY) then
      if player:GetMaxHearts() ~= 0 then
        player.MoveSpeed = player.MoveSpeed + (1 - (player:GetHearts() / player:GetMaxHearts()))
        data.TI_BodyHearts = player:GetHearts()
      else
        if player:GetSoulHearts() <= 16 then
          player.MoveSpeed = player.MoveSpeed + (1 - (player:GetSoulHearts() / 16))
        elseif player.MoveSpeed ~= data.TI_BodyMoveSpeed then
          player.MoveSpeed = data.TI_BodyMoveSpeed
        end
        data.TI_BodyHearts = player:GetSoulHearts()
      end
    end
  end
  if flag == CacheFlag.CACHE_RANGE then
    -- Lemon Mishap stats (should be identical to Number One)
    -- Isaac's range is -23.75, tear delay is 10.0, falling speed is -0.1834
    -- With Number One, range is -5.75, tear delay is 5.6947, falling speed is 0.9722
    if data.TI_IsPissingThemselves and not data.TI_AppliedLemonEffect then
      player.TearHeight = player.TearHeight + 18
      player.MaxFireDelay = player.MaxFireDelay - 4.3053
      data.TI_AppliedLemonEffect = true
    end
    if not data.TI_IsPissingThemselves and data.TI_AppliedLemonEffect then
      player.TearHeight = player.TearHeight - 18
      player.MaxFireDelay = player.MaxFireDelay + 4.3053
      data.TI_AppliedLemonEffect = false
    end
    -- Ipecac
    player.TearFallingAcceleration = player.TearFallingAcceleration + (0.512 * player:GetCollectibleNum(mod.COLLECTIBLE_IPECAC))
    player.TearFallingSpeed = player.TearFallingSpeed + (9.5076 * player:GetCollectibleNum(mod.COLLECTIBLE_IPECAC))
  end
  if flag == CacheFlag.CACHE_DAMAGE then
    -- Chemical Peel, Ipecac, SMB Super Fan, Magic Mushroom
    player.Damage = player.Damage + (1.16 * player:GetCollectibleNum(mod.COLLECTIBLE_CHEMICAL_PEEL)) + (player.Damage * 3 * player:GetCollectibleNum(mod.COLLECTIBLE_IPECAC)) + (player.Damage * player:GetCollectibleNum(mod.COLLECTIBLE_SMB_SUPER_FAN)) + (player.Damage * 1.3 * player:GetCollectibleNum(mod.COLLECTIBLE_MAGIC_MUSHROOM) * (data.TI_PoweredUp and 1 or 0))
  end
  if flag == CacheFlag.CACHE_FAMILIARS then
    -- 1up
    player:CheckFamiliar(FamiliarVariant.ONE_UP, player:GetCollectibleNum(mod.COLLECTIBLE_1UP), player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_1UP))
  end
  if flag == CacheFlag.CACHE_SIZE then
    -- Magic Mushroom
    player.SpriteScale = player.SpriteScale + (Vector(0.25006, 0.25006) * player:GetCollectibleNum(mod.COLLECTIBLE_MAGIC_MUSHROOM) * (data.TI_PoweredUp and 1 or 0))
  end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player)
  local data = player:GetData()
  if not data.TI_IsPissingThemselves then
    data.TI_IsPissingThemselves = true
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
      player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE), false)
      data.TI_OriginalTearColor = player.TearColor
      player.TearColor = Color(1, 1, 0, 1, 0.1765, 0.0588, 0)
      player:AddCacheFlags(CacheFlag.CACHE_RANGE)
      player:EvaluateItems()
    end
  end
  return true
end, mod.COLLECTIBLE_LEMON_MISHAP)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player)
  local tainted = false
  local cleaned = false
  for _,p in ipairs(Isaac.FindByType(5, 100)) do
    if p:GetData().IsTaintedPedestal or mod:IsTaintedItem(p.SubType) then
      cleaned = true
    else
      tainted = true
    end
    mod:TaintItemPedestal(p)
  end
  if tainted then
    sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 0, false, 1.0)
    game:GetRoom():EmitBloodFromWalls(3, 10)
  end
  if cleaned then sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1.0) end
  return true
end, mod.COLLECTIBLE_SPINDOWN_DICE)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player)
  local allPickups = {}
  for i=4,5 do
    for _,p in ipairs(Isaac.FindByType(i, -1)) do
      table.insert(allPickups, p)
    end
  end
  for _,p in ipairs(allPickups) do
    local flip = mod:FlipPickup(p.Type, p.Variant, p.SubType)
    if flip then
      local pos = p.Position
      p:Remove()
      Isaac.Spawn(flip[1], flip[2], flip[3], pos, Vector.Zero, nil)
    end
  end
  return true
end, mod.COLLECTIBLE_D20)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player)
  local room = game:GetRoom()
  local spawnPos = room:FindFreePickupSpawnPosition(player.Position, 20, true)
  sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1.0)
  local sin = Isaac.Spawn(mod.TheSins[math.random(1, #mod.TheSins)], math.random(0, 1), 0, spawnPos, Vector.Zero, nil)
  sin:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
  for i=0,7 do
    local door = room:GetDoor(i)
    if door then door:Close(true) end
  end
  return true
end, mod.COLLECTIBLE_BOOK_OF_SIN)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
  if tear:IsDead() then
    local player = tear.Parent:ToPlayer()
    if player:HasCollectible(mod.COLLECTIBLE_IPECAC) then
      mod:SpawnIpecacCreep(player, tear)
    end
    if player:GetData().IsPissingThemselves then
      mod:SpawnLemonMishapCreep(player, tear)
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, ent)
  local player = tear.Parent:ToPlayer()
  if player:HasCollectible(mod.COLLECTIBLE_IPECAC) then
    if ent:IsVulnerableEnemy() then
      ent:AddPoison(EntityRef(player), 105, 1)
    end
    mod:SpawnIpecacCreep(player, tear)
  end
  if player:GetData().IsPissingThemselves then
    mod:SpawnLemonMishapCreep(player, tear)
  end 
end)

--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function (_, effect)
--  if effect.Variant == EffectVariant.CREEP_RED then
--    local color = Color(1, 1, 1, 1, 0, 0, 0)
--    color:SetColorize(8, (243/255)*8, 0, 1)
--    effect:GetSprite().Color = color
--  end
--end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
  if not pickup.SubType == mod.PICKUP_TAINTED_KEY then return end 
  local sprite = pickup:GetSprite()
	if sprite:IsEventTriggered("DropSound") then
		sfx:Play(SoundEffect.SOUND_KEY_DROP0, 1, 0, false, 1.0)
	end
end, mod.PICKUP_BASE_ID)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, ent)
  if not pickup.SubType == mod.PICKUP_TAINTED_KEY then return end 
  local player = ent:ToPlayer()
  if not player then return end
  local sprite = pickup:GetSprite()
  if not (sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle")) then
    return false
  end
  mod.Data.HasKey = true
  sfx:Play(SoundEffect.SOUND_GOLDENKEY, 1, 0, false, 0.8)
  pickup.Velocity = Vector.Zero
  pickup.Touched = true
  pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
  sprite:Play("Collect", true)
	pickup:Die()
end, mod.PICKUP_BASE_ID)

--mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function(_, dropRNG, spawnPos)
--  if room:GetType() == RoomType.ROOM_BOSS then
--    print("should spawn tainted key")
--    spawnPos = room:FindFreePickupSpawnPosition(spawnPos, 10, true)
--    Isaac.Spawn(5, mod.PICKUP_BASE_ID, mod.PICKUP_TAINTED_KEY, spawnPos, Vector.Zero, nil)
--  end
--end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
  local room = game:GetRoom()
  if room:GetType() ~= RoomType.ROOM_BOSS then return end
  if npc:IsBoss() and Isaac.CountBosses() == 1 and mod:RollForKey() then
    local spawnPos = room:FindFreePickupSpawnPosition(npc.Position, 10, true)
    Isaac.Spawn(5, mod.PICKUP_BASE_ID, mod.PICKUP_TAINTED_KEY, spawnPos, Vector(1, 0):Resized(4):Rotated(math.random(0, 360)), nil)
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_)
  if mod.Data.HasKey then
    mod.Data.HasKey = false
  end
  mod:UpdateKeyChance()
  for i = 1, game:GetNumPlayers() do
    local player = Isaac.GetPlayer(i - 1)
    if player:HasCollectible(mod.COLLECTIBLE_MAGIC_MUSHROOM) and player:GetData().TI_PoweredUp == false then
      player:GetData().TI_ReadyForPowerUp = true
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
  local room = game:GetRoom()
  if room:GetType() == RoomType.ROOM_TREASURE and mod.Data.HasKey then
    for _,p in ipairs(Isaac.FindByType(5, 100)) do
      if not p:GetData().IsTaintedPedestal and not mod:IsTaintedItem(p.SubType) then
        mod:TaintItemPedestal(p)
      end
    end
    mod.Data.HasKey = false
  end
  for i = 1, game:GetNumPlayers() do
    local player = Isaac.GetPlayer(i - 1)
    local data = player:GetData()
    if data.TI_IsPissingThemselves then
      data.TI_IsPissingThemselves = false
      if not player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
        player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
        player.TearColor = data.TI_OriginalTearColor
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        player:EvaluateItems()
      end
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
  if mod:IsTaintedItem(pickup.SubType) then
    local sprite = pickup:GetSprite()
    sprite:ReplaceSpritesheet(5, "gfx/items/levelitem_001_itemaltar_tainted.png")
    sprite:LoadGraphics()
    pickup:GetData().IsTaintedPedestal = true
  end
end, 100)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
  local gottaShrink = false
  for i = 1, game:GetNumPlayers() do
    local player = Isaac.GetPlayer(i - 1)
    if (player:HasCollectible(mod.COLLECTIBLE_POLYPHEMUS) and not gottaShrink) then gottaShrink = true end
  end
  if gottaShrink then
    if npc:IsBoss() then
      npc.Scale = 0.75
    else
      npc.Scale = 0.5
    end
    npc:GetData().TI_Shrunk = true
  end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, amt, flags, src)
  local player = ent:ToPlayer()
  if player then
    if player:GetData().TI_IsLosingPowerUp then return false end
    if player:GetData().TI_PoweredUp then 
      mod:MushroomPowerUp(player, false) 
      return false
    end
  end
  if src.Entity then
    if ent:IsVulnerableEnemy() and src.Entity:GetData().TI_IpecacCreep then
      ent:AddPoison(src, 165, 1)
    end
  end
  if ent:GetData().TI_Shrunk and flags & DamageFlag.DAMAGE_CLONES == 0 then
    local mod = 2
    if ent:IsBoss() then mod = 1.5 end
    ent:TakeDamage(amt * mod, flags | DamageFlag.DAMAGE_CLONES, src, 0)
    return false
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
  local player = tear.Parent:ToPlayer()
  if player:HasCollectible(mod.COLLECTIBLE_CHEMICAL_PEEL) then tear:ChangeVariant(TearVariant.BLOOD) end
end)

--print(player.TearColor.R .. "/" .. player.TearColor.G .. "/" .. player.TearColor.B .. "/" .. player.TearColor.A .. "/" .. player.TearColor.RO .. "/" .. player.TearColor.GO .. "/" .. player.TearColor.BO)
