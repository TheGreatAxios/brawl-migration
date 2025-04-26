// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {HeroData} from "./HeroData.sol";

error InvalidClan();
error InvalidClass();
error InvalidAddress();
error MintLimitReached();

contract BrawlHeroes is ERC721, ERC721Burnable, AccessControl, HeroData {
    
    struct MintableHero {
        address to;
        uint256 tokenId;
        uint256 heroCode;
    }

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public constant MINTS_ALLOWED = 15575;
    uint256 public currentTokenId;
    string public baseURI;
    string public heroImageSuffix;

    // tokenId => heroCode
    mapping(uint256 => uint256) public heroCodes;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI,
        string memory _heroImageSuffix
    ) ERC721(_name, _symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
        baseURI = _baseURI;
        heroImageSuffix = _heroImageSuffix;
    }

    function mintBatch(MintableHero[] memory heroes) public onlyRole(MINTER_ROLE) {
        uint256 len = heroes.length;
        if (len > 250) revert("Batch too large");
        
        for (uint256 i = 0; i < len; i++) {
            if (currentTokenId > MINTS_ALLOWED) revert MintLimitReached();
            if (heroes[i].to == address(0)) revert InvalidAddress();
        
            _safeMint(heroes[i].to, heroes[i].tokenId);
            heroCodes[heroes[i].tokenId] = heroes[i].heroCode;
            
            currentTokenId++;
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        // require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        
        // Retrieve the hero token data (assuming you have a method to get the token)
        HeroToken memory heroToken = generateHeroToken(heroCodes[tokenId]);
        
        // Break down the JSON creation into smaller parts
        string memory basicAttributes = string(
            abi.encodePacked(
                '{"trait_type": "Level", "value": ', Strings.toString(heroToken.level), '},',
                '{"trait_type": "Clan", "value": ', Strings.toString(heroToken.clan), '},',
                '{"trait_type": "Class", "value": ', Strings.toString(heroToken.class), '},',
                '{"trait_type": "Alignment", "value": ', Strings.toString(heroToken.alignment), '}'
            )
        );
        
        string memory combatAttributes = string(
            abi.encodePacked(
                '{"trait_type": "Attack Stat", "value": ', Strings.toString(heroToken.attackStat), '},',
                '{"trait_type": "Cooldown", "value": ', Strings.toString(heroToken.cooldown), '}'
            )
        );
        
        string memory statsAttributes = string(
            abi.encodePacked(
                '{"trait_type": "Strength", "value": ', Strings.toString(heroToken.stats[0]), '},',
                '{"trait_type": "Magic", "value": ', Strings.toString(heroToken.stats[1]), '},',
                '{"trait_type": "Dexterity", "value": ', Strings.toString(heroToken.stats[2]), '},',
                '{"trait_type": "HP", "value": ', Strings.toString(heroToken.stats[3]), '}'
            )
        );
        
        string memory additionalAttributes = string(
            abi.encodePacked(
                '{"trait_type": "Ability Ranks", "value": ', Strings.toString(heroToken.abilityRanks), '},',
                '{"trait_type": "Combat Slot", "value": ', Strings.toString(heroToken.combatSlot), '}'
            )
        );
        
        // Combine attributes
        string memory combinedAttributes = string(
            abi.encodePacked(
                basicAttributes, ',', 
                combatAttributes, ',', 
                statsAttributes, ',', 
                additionalAttributes
            )
        );
        
        // Generate full JSON
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{',
                            '"name": "Hero #', Strings.toString(heroToken.heroID), '",',
                            '"description": "Legendary Hero with unique attributes",',
                            '"attributes": [',
                                combinedAttributes,
                            '],',
                            '"image": "',baseURI,getClass(heroToken.class),'_',getClan(heroToken.clan),'.',heroImageSuffix,'"'
                        '}'
                    )
                )
            )
        );
        
        // Construct the tokenURI with base64 encoded JSON
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                json
            )
        );
    }

    function getClass(uint256 class) public pure returns (string memory) {
        if (class == 60) return "barbarian";
        if (class == 61) return "warrior";
        if (class == 62) return "knight";
        if (class == 63) return "amazon";
        if (class == 64) return "rogue";
        if (class == 65) return "monk";
        if (class == 67) return "cleric";
        if (class == 68) return "witch";
        revert InvalidClass();
    }

    function getClan(uint256 clan) public pure returns (string memory) {
        if (clan == 28) return "fire";
        if (clan == 29) return "water";
        if (clan == 30) return "air";
        if (clan == 31) return "earth";
        if (clan == 32) return "doom";
        revert InvalidClan();
    }

    function generateHeroToken(uint256 heroCode) public pure returns (HeroToken memory) {
        HeroToken memory heroToken;

        // Extract Metagame Data
        (
            heroToken.heroID, 
            /* goldBalance */, 
            heroToken.cooldown, 
            heroToken.level, 
            /* xp */
        ) = _getMetagameData(heroCode);

        // Extract Characteristics
        (
            heroToken.clan, 
            heroToken.class, 
            heroToken.alignment
        ) = _getCharacteristics(heroCode);

        // Extract Combat Stats
        (
            heroToken.stats[0],  // strength
            heroToken.stats[1],  // magic
            heroToken.stats[2],  // dexterity
            heroToken.stats[3]   // hp
        ) = _getCombatStats(heroCode);

        // Extract Abilities
        (
            heroToken.abilities, 
            heroToken.abilityRanks
        ) = _getAbilities(heroCode);

        // Calculate attack stat (if needed)
        // This is a placeholder - you might want to implement your specific attack stat calculation
        heroToken.attackStat = heroToken.stats[0] + heroToken.stats[1];

        // Set combat slot (if applicable)
        heroToken.combatSlot = 0; // You can modify this as needed

        return heroToken;
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}