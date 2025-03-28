// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// @title HeroData
// @dev This is used so that any contract can manipulate the raw game data correctly.
// @author Block Brawlers (https://www.blockbrawlers.com)
// (c) 2022 Block Brawlers LLC. All Rights Reserved. This code is not open source.
contract HeroData {
  // @dev The main HeroToken object struct.
  // Every game object is represented by a copy of this struct,
  //  and it fits exactly into a single 256-bit word.
  // @dev: ONLY store this in memory. It's 20 memory locations, so it's not cheap...
  struct HeroToken {
    uint256 attackStat;
    // uint goldBalance; // gold balance isn't used in combat
    uint256 cooldown;
    uint256 heroID;
    uint256 level;
    // uint xp; // xp isn't used in combat
    uint256 clan;
    uint256 class;
    uint256 alignment;
    uint256[4] stats; // str/mag/dex/hp
    uint256[7] abilities;
    uint256 abilityRanks; // encoded as a
    uint256 combatSlot;
  }

  // @dev gets the heroID, gold, cooldown, level, and Xp of a hero
  // @param _code - the heroCode to be queried
  // @return _heroID - the heroID of the hero
  // @return _goldBalance - the goldBalance of the hero
  // @return _cooldown - the cooldown of the hero
  // @return _level - the level of the hero
  // @return _xp - the xp of the hero
  function getMetagameData(uint256 _code)
    external
    pure
    returns (
      uint256 _heroID,
      uint256 _goldBalance,
      uint256 _cooldown,
      uint256 _level,
      uint256 _xp
    )
  {
    _heroID = uint256(uint32(_code >> 224));
    _goldBalance = uint256(uint24(_code >> 184));
    _cooldown = uint256(uint32(_code >> 152));
    _level = uint256(uint8(_code >> 144)); // need to use less to encode this?
    _xp = uint256(uint16(_code >> 128));
  }

  // @dev gets the clan, class, and alignment values of a hero
  // @param _code - the heroCode to be queried
  // @return _clan - the clan of the heroCode
  // @return _class - the class of the heroCode
  // @return _alignment - the alignment of the heroCode
  function getCharacteristics(uint256 _code)
    external
    pure
    returns (
      uint256 _clan,
      uint256 _class,
      uint256 _alignment
    )
  {
    _clan = uint256((_code >> 120) & 127); // 6-bit == 64
    _class = uint256((_code >> 113) & 127); // 6-bit == 64
    _alignment = uint256((_code >> 109) & 15); // 4-bit == 16
  }

  // @dev gets the strength, magic, dex, and hp values of a hero
  // @param _code - the heroCode to be queried
  // @return _str - the strength of the heroCode
  // @return _mag - the magic of the heroCode
  // @return _dex - the dexterity of the heroCode
  // @return _hp - the hit points of the heroCode
  function getCombatStats(uint256 _code)
    external
    pure
    returns (
      uint256 _str,
      uint256 _mag,
      uint256 _dex,
      uint256 _hp
    )
  {
    _str = uint256(uint8(_code >> 101));
    _mag = uint256(uint8(_code >> 93));
    _dex = uint256(uint8(_code >> 85));
    _hp = uint256(uint8(_code >> 77));
  }

  // @dev gets the set of abilities for the heroCode
  // @param _code - the heroCode to be queried
  // @return abilities - An array of ability codes
  // @return abilityRank - An encoded uint, holding the seven ability ranks
  function getAbilities(uint256 _code)
    external
    pure
    returns (uint256[7] memory abilities, uint256 abilityRank)
  {
    abilities[6] = uint256(uint8(_code >> 69));
    abilities[5] = uint256(uint8(_code >> 61));
    abilities[4] = uint256(uint8(_code >> 53));
    abilities[3] = uint256(uint8(_code >> 45));
    abilities[2] = uint256(uint8(_code >> 37));
    abilities[1] = uint256(uint8(_code >> 29));
    abilities[0] = uint256(uint8(_code >> 21));
    abilityRank = uint256(_code & (2**21 - 1));
  }

  // @dev gets the heroID, gold, cooldown, level, and Xp of a hero
  // @param _code - the heroCode to be queried
  // @return _heroID - the heroID of the hero
  // @return _goldBalance - the goldBalance of the hero
  // @return _cooldown - the cooldown of the hero
  // @return _level - the level of the hero
  // @return _xp - the xp of the hero
  function _getMetagameData(uint256 _code)
    internal
    pure
    returns (
      uint256 _heroID,
      uint256 _goldBalance,
      uint256 _cooldown,
      uint256 _level,
      uint256 _xp
    )
  {
    _heroID = uint256(uint32(_code >> 224));
    _goldBalance = uint256(uint24(_code >> 184));
    _cooldown = uint256(uint32(_code >> 152));
    _level = uint256(uint8(_code >> 144));
    _xp = uint256(uint16(_code >> 128));
  }

  // @dev gets the heroID, cooldown, and level of a hero
  // @param _code - the heroCode to be queried
  // @return _heroID - the heroID of the hero
  // @return _cooldown - the cooldown of the hero
  // @return _level - the level of the hero
  function _getIdCooldownLevel(uint256 _code)
    internal
    pure
    returns (
      uint256 _heroID,
      uint256 _cooldown,
      uint256 _level
    )
  {
    _heroID = uint256(uint32(_code >> 224));
    _cooldown = uint256(uint32(_code >> 152));
    _level = uint256(uint8(_code >> 144));
  }

  // @dev gets the clan, class, and alignment values of a hero
  // @param _code - the heroCode to be queried
  // @return _clan - the clan of the heroCode
  // @return _class - the class of the heroCode
  // @return _alignment - the alignment of the heroCode
  function _getCharacteristics(uint256 _code)
    internal
    pure
    returns (
      uint256 _clan,
      uint256 _class,
      uint256 _alignment
    )
  {
    _clan = uint256((_code >> 120) & 127); // 6-bit == 64
    _class = uint256((_code >> 113) & 127); // 6-bit == 64
    _alignment = uint256((_code >> 109) & 15); // 4-bit == 16
  }

  // @dev gets the strength, magic, dex, and hp values of a hero
  // @param _code - the heroCode to be queried
  // @return _str - the strength of the heroCode
  // @return _mag - the magic of the heroCode
  // @return _dex - the dexterity of the heroCode
  // @return _hp - the hit points of the heroCode
  function _getCombatStats(uint256 _code)
    internal
    pure
    returns (
      uint256 _str,
      uint256 _mag,
      uint256 _dex,
      uint256 _hp
    )
  {
    _str = uint256(uint8(_code >> 101));
    _mag = uint256(uint8(_code >> 93));
    _dex = uint256(uint8(_code >> 85));
    _hp = uint256(uint8(_code >> 77));
  }

  // @dev gets the set of abilities for the heroCode
  // @param _code - the heroCode to be queried
  // @return abilities - An array of ability codes
  // @return abilityRank - An encoded uint, holding the seven ability ranks
  function _getAbilities(uint256 _code)
    internal
    pure
    returns (uint256[7] memory abilities, uint256 abilityRank)
  {
    abilities[6] = uint256(uint8(_code >> 69));
    abilities[5] = uint256(uint8(_code >> 61));
    abilities[4] = uint256(uint8(_code >> 53));
    abilities[3] = uint256(uint8(_code >> 45));
    abilities[2] = uint256(uint8(_code >> 37));
    abilities[1] = uint256(uint8(_code >> 29));
    abilities[0] = uint256(uint8(_code >> 21));
    abilityRank = uint256(_code & (2**21 - 1));
  }

  // @dev sets the heroID, gold, cooldown, level, and Xp of a hero
  //  used for creating and leveling up stats
  // @param _code - the heroCode to be changed
  // @param _heroID - the heroID to set
  // @param _goldBalance - the goldBalance to set
  // @param _cooldown - the cooldown to set
  // @param _level - the level to set
  // @param _xp - the xp to set
  // @return the updated hero code
  function setMetagameData(
    uint256 _code,
    uint256 _heroID,
    uint256 _goldBalance,
    uint256 _cooldown,
    uint256 _level,
    uint256 _xp
  ) public pure returns (uint256) {
    // Ensure gold is capped, rather than overflows
    _goldBalance = _goldBalance > 2**24 - 1 ? 2**24 - 1 : _goldBalance;
    _code = _code & ~(uint256(2**128 - 1) << 128);
    _code = _code | (uint256(uint32(_heroID)) << 224);
    _code = _code | (_goldBalance << 184);
    _code = _code | (uint256(uint32(_cooldown)) << 152);
    _code = _code | (uint256(uint8(_level)) << 144);
    _code = _code | (uint256(uint16(_xp)) << 128);
    return _code;
  }

  // @dev set the clan, class, and alignment, and hp values of a hero
  // @param _code - the heroCode to be changed
  // @param _clan - the clan to set
  // @param _class - the class to set
  // @param _alignment - the alignment to set
  // @return the updated hero code
  function _setCharacteristics(
    uint256 _code,
    uint256 _clan,
    uint256 _class,
    uint256 _alignment
  ) internal pure returns (uint256) {
    _code = _code & ~(uint256(2**18 - 1) << 109);
    _code = _code | (uint256(_clan & 127) << 120);
    _code = _code | (uint256(_class & 127) << 113);
    _code = _code | (uint256(_alignment & 15) << 109);
    return _code;
  }

  // @dev set the strength, magic, dex, and hp values of a hero
  // @param _code - the heroCode to be changed
  // @param _str - the strength to set
  // @param _mag - the magic to set
  // @param _dex - the dexterity to set
  // @param _hp - the hit points to set
  // @notice Caps the stats at 255, so they won't overflow
  // @return the updated hero code
  function _setCombatStats(
    uint256 _code,
    uint256 _str,
    uint256 _mag,
    uint256 _dex,
    uint256 _hp
  ) internal pure returns (uint256) {
    // Capping these to 255, rather than truncating.
    _str = _str > 255 ? 255 : _str;
    _mag = _mag > 255 ? 255 : _mag;
    _dex = _dex > 255 ? 255 : _dex;
    _hp = _hp > 255 ? 255 : _hp;
    _code = _code & ~(uint256(2**32 - 1) << 77);
    _code = _code | (_str << 101);
    _code = _code | (_mag << 93);
    _code = _code | (_dex << 85);
    _code = _code | (_hp << 77);
    return _code;
  }

  // @dev set the cooldown value of a hero
  // @param _code - the heroCode to be changed
  // @param cooldown - the current cooldown of the hero
  // @notice Caps the cooldown at 2**32-1, so it won't overflow
  // @notice Cooldowns will stop working in 2106.
  // @return the updated hero code
  function setCooldown(uint256 _code, uint256 cooldown)
    public
    pure
    returns (uint256)
  {
    _code = _code & ~(uint256(2**32 - 1) << 152);
    cooldown = cooldown > 2**32 - 1 ? 2**32 - 1 : cooldown;
    return _code | (uint256(uint32(cooldown)) << 152);
  }

  // @dev set the XP value of a hero
  // @param _code - the heroCode to be changed
  // @param xp - the current xp of the hero
  // @notice Caps the xp at 2**16-1, so it won't overflow
  // @return the updated hero code
  function setXp(uint256 _code, uint256 xp) public pure returns (uint256) {
    _code = _code & ~(uint256(2**16 - 1) << 128);
    xp = xp > 2**16 - 1 ? 2**16 - 1 : xp;
    return _code | (uint256(uint16(xp)) << 128);
  }

  // @dev set the gold value of a hero
  // @param _code - the heroCode to be changed
  // @param gold - the gold balance of the hero
  // @notice Caps the gold balance at 2**24-1, so it won't overflow
  // @return the updated hero code
  function _setGold(uint256 _code, uint256 gold)
    internal
    pure
    returns (uint256)
  {
    gold = gold > 2**24 - 1 ? 2**24 - 1 : gold;
    _code = _code & ~(uint256(2**24 - 1) << 184);
    return _code | (gold << 184);
  }

  function addGold(uint256 _code, uint256 goldAdded)
    public
    pure
    returns (uint256)
  {
    uint256 currentGold = uint256(uint24(_code >> 184));
    currentGold += goldAdded;
    currentGold = currentGold > 2**24 - 1 ? 2**24 - 1 : currentGold;
    _code = _code & ~(uint256(2**24 - 1) << 184);
    return _code | (currentGold << 184);
  }

  function _subtractGold(uint256 _code, uint256 goldSubtracted)
    internal
    pure
    returns (uint256)
  {
    uint256 currentGold = uint256(uint24(_code >> 184));
    currentGold = goldSubtracted > currentGold
      ? 0
      : currentGold - goldSubtracted;
    _code = _code & ~(uint256(2**24 - 1) << 184);
    return _code | (currentGold << 184);
  }

  // @dev Adds a new ability on a hero. Do NOT try to remove or reset using this.
  // @notice Abilities are set to a starting rank of 1-5. Can rank up to 7 (so 8 total ranks)
  // @notice This ensures no duplicate abilities on heroes - a duplicate becomes a rank up instead
  // @param _code - the heroCode to be changed
  // @param ability - the abilityID to gain (1-255)
  // @param rank - the rank of the ability to gain (needs to be 1 =< rank <= 7)
  // @param slot - the ability slot to be upgraded
  // @return the updated hero code
  function _addAbility(
    uint256[7] memory abilities,
    uint256 _code,
    uint256 ability,
    uint256 slot
  ) internal pure returns (uint256) {
    /*for (uint i = 0; i < slot; i++) {
      uint existingAbility = abilities[i];
      if (ability == existingAbility) {
        return _rankUpAbility(_code, slot);
      }
    }*/
    abilities[slot] = ability;
    uint256 shift = slot * 8 + 21;
    uint256 shiftRank = slot * 3;
    _code = _code & ~((uint256(2**8 - 1) << shift) & (uint256(7) << shiftRank));
    return
      _code |
      (uint256(uint8(ability)) << shift) |
      (((slot <= 1 ? 1 : slot - 1) & 7) << shiftRank);
  }

  // @dev Adds one rank to the selected ability.
  // @notice Won't allow the ability to go over rank 7.
  // @param _code - the heroCode to be changed
  // @param slot - the ability slot to be upgraded
  // @return the updated hero code
  function _rankUpAbility(uint256 _code, uint256 slot)
    internal
    pure
    returns (uint256)
  {
    uint256 shiftRank = slot * 3;
    uint256 rank = uint256((_code >> shiftRank) & 7);
    if (rank < 7) {
      _code = _code & ~(uint256(7) << shiftRank);
      return _code | ((rank + 1) << shiftRank);
    } else {
      return _code;
    }
  }

  // @dev Generates a psuedo-random number.
  // @param seed - the seed used to modify the blockhash, so multiple different numbers
  //  can be generated each block
  function _getLongRandom(uint256 seedA, uint256 seedB)
    internal
    pure
    returns (uint256)
  {
    uint256 random = uint256(keccak256(abi.encodePacked(seedA, seedB)));
    return random;
  }
}