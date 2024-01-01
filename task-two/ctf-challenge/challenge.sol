// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {S_M} from "./secret_missive.sol";

contract GUILD_AUDIT_CHALLENGE is S_M {
    //
    //    _____       _ _     _                   _ _ _      _____ _           _ _                         ___    ___
    //   / ____|     (_) |   | |   /\            | (_) |    / ____| |         | | |                       |__ \  / _ \
    //  | |  __ _   _ _| | __| |  /  \  _   _  __| |_| |_  | |    | |__   __ _| | | ___ _ __   __ _  ___     ) || | | |
    //  | | |_ | | | | | |/ _` | / /\ \| | | |/ _` | | __| | |    | '_ \ / _` | | |/ _ \ '_ \ / _` |/ _ \   / / | | | |
    //  | |__| | |_| | | | (_| |/ ____ \ |_| | (_| | | |_  | |____| | | | (_| | | |  __/ | | | (_| |  __/  / /_ | |_| |
    //   \_____|\__,_|_|_|\__,_/_/    \_\__,_|\__,_|_|\__|  \_____|_| |_|\__,_|_|_|\___|_| |_|\__, |\___| |____(_)___/
    //                                                                                         __/ |
    //                                                                                        |___/

    //Levels
    bytes constant LEVEL_A = (abi.encodePacked("Level A"));
    bytes constant LEVEL_B = (abi.encodePacked("Level B"));
    bytes constant LEVEL_C = (abi.encodePacked("Level C"));
    bytes constant LEVEL_D = (abi.encodePacked("Level D"));

    mapping(address => mapping(bytes => bool)) public levels;
    mapping(bytes => bool) public unlocked;

    error LevelNotPassed(string);

    //level B
    mapping(address => uint256) public trustCount;

    //level D
    mapping(address => address) public registeredProxies;

    event LevelUnlocked(address opener, string level, uint256 timeFired);
    event MasterLevelUnlocked(address opener, string level, uint256 timeFired);
    event PrincipalChanged(address culprit, address newPrincipal, uint256 timeFired);
    event ProxyRegistered(address registrar, address proxy, uint256 timeFired);

    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function solve_challenge_A(bytes32 c__) public payable {
        __hasNotSolved__(LEVEL_A);
        address $t$;
        address $o$;
        assembly {
            $t$ := caller()
        }
        assembly {
            $o$ := origin()
        }
        require(msg.value == (uint32(uint160($t$)) & 0xffff) / 100, "Is it for beans?");
        require(c__ == keccak256(abi.encode("0x44\\0x33\\0x22\\0x11\\0x00", $o$)), "Is it for garri");

        unlocked[LEVEL_A] = true;

        levels[tx.origin][LEVEL_A] = true;
        emit LevelUnlocked(tx.origin, string(LEVEL_A), block.timestamp);
    }

    event DiSCoNnEcTeD();

    function solve_challenge_B() public {
        __hasSolved__(LEVEL_A);
        __hasNotSolved__(LEVEL_B);

        if (trustCount[msg.sender] != 0) {
            //short-circuit and revert slot
            trustCount[msg.sender] = 0;
            emit DiSCoNnEcTeD();
        }
        (bool result,) = msg.sender.call("");
        if (result) {
            trustCount[msg.sender]++;
            if (trustCount[msg.sender] == uint8(uint256(keccak256("solved"))) % 15) {
                unlocked[LEVEL_B] = true;

                levels[tx.origin][LEVEL_B] = true;
                emit MasterLevelUnlocked(tx.origin, string(LEVEL_B), block.timestamp);
            }
        }
    }

    address currentPrincipal;

    function solve_challenge_C(address _newPrincipal) public {
        if (tx.origin != msg.sender) {
            if (_newPrincipal.code.length > 0) {
                revert("Idan no suppose get code");
            }
            currentPrincipal = _newPrincipal;
            emit PrincipalChanged(tx.origin, _newPrincipal, block.timestamp);
        }
    }

    function get_C_Profit() public {
        __hasNotSolved__(LEVEL_C);
        if (tx.origin != currentPrincipal) revert("Not Principal");

        unlocked[LEVEL_C] = true;

        levels[tx.origin][LEVEL_C] = true;
        emit LevelUnlocked(msg.sender, string(LEVEL_C), block.timestamp);
    }

    function solve_challenge_D(address _proxy) public {
        __hasSolved__(LEVEL_C);
        if (_proxy.code.length > 0) revert("PROXIES MUST NOT CONTAIN CODE");
        //register proxy for user
        registeredProxies[tx.origin] = _proxy;
        emit ProxyRegistered(tx.origin, _proxy, block.timestamp);
    }

    function solve_challenge_D2() public {
        __hasSolved__(LEVEL_C);
        __hasNotSolved__(LEVEL_D);
        assert(registeredProxies[tx.origin] != address(0));
        if (registeredProxies[tx.origin].code.length == 0) {
            revert("PROXIES SHOULD CONTAIN CODE");
        }
        assert(
            S_M(registeredProxies[tx.origin]).__expected__().__boom__
                == uint16(bytes2(bytes16(keccak256(abi.encode(registeredProxies[tx.origin])))))
        );

        unlocked[LEVEL_D] = true;

        levels[tx.origin][LEVEL_D] = true;
        emit LevelUnlocked(msg.sender, string(LEVEL_D), block.timestamp);
    }

    //checks
    function __hasSolved__(bytes memory _level) public view {
        string memory level = string(_level);
        if (!levels[tx.origin][_level]) revert LevelNotPassed(level);
    }

    function __hasNotSolved__(bytes memory _level) public view {
        if (levels[tx.origin][_level]) revert("LevelPassed");
    }

    function __isOwner__() public view {
        if (msg.sender != owner) revert("Not owner");
    }

    receive() external payable {}

    //     .
    //     .
    //     .
    //     .
    //     .
    //     .
    //     .
    //     .
    //     .
    //     .
    //     .
    // .
    //     .
    //     .
    //     .
    //     .

    //     .
    //     .
    //     .
    //     .
    //     .
    // .
    //     .
    //     .

    function __expected__() external pure returns (MSS_SS_SSM memory) {}
}
