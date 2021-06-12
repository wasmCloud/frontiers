# wasmCloud Frontiers

A player-generated content game of random collaboration, resource and construction strategy, and tower defense.

---

# Developer Generated Content

## MUDS, MUCK, MOO, MUSH, etc
Once a player becomes a "wizard", they could code their "castle" in the game world, sometimes
even while connected to the game! (circa 1993)

## ROBLOX
Using a simplified game engine editor, players can make their own sub-games and other interactive,
engaging activities in the Roblox universe.

## Minecraft
Server mods let people do all kinds of things to Minecraft, even run Kubernetes

---

# Design Goals
The following are the high-level goals for this game.

1. Developers learn wasmCloud through play
2. Online, Interconnected
3. Supports Network Partitions, Occasionally Offline
4. Making the game must be as fun as playing the game

---
# Getting Started

1. Go to https://frontiers.wasmcloud.dev
2. Sign In/Sign Up
3. Generate a Frontier Seed Key
4. Create a Frontier
5. Start the _"Frontiers Capability Provider"_ in your host
6. Start your hero actors in your host
7. Set link definitions for your heros-->_frontiers provider_.
8. Monitor your frontier's progress online at the Frontiers website

---
# Gameplay - Creating Frontier Heros

A frontier **hero** is a wasmCloud actor, signed with the `wasmcloud:frontiers` capability
contract.

Heros:

* Harvest
* Move
* Build
* Tear Down

---
# Gameplay - The Wormhole

At random, a **wormhole** appears, swallowing a hero from your frontier and depositing a hero from
_someone else's_ frontier. Eventually, your frontier may be defended entirely by other people's heros.

Players may have a maximum of **4** heros defending their frontier at any given time.

---
# Gameplay - The Hordes

At random, a **horde** will appear, seeking to make its way through your frontier's outer defenses to raid
and ransack your storage silo--the lifeblood of your frontier's citizens. 

If your heros have done their jobs, the attack may be repelled. 
If not, your citizens may be eating nothing but grass and berries by fall.

---
# The Architecture

wasmCloud Frontiers will (likely) be split up into the following pieces:

* wasmCloud Host Runtime
* Central website (`frontiers.wasmcloud.dev`)
* Frontiers Capability Provider (the semi-connected "game engine")
* Your Hero Actors
* NATS and NGS, the message broker that connects everything

---
# Architecture Diagram
The following is a rough depiction of what the game architecture looks like:

```
                  .---------------------------------.
                  | Frontiers Website (Phoenix/OTP) |
                  `---------------------------------'
                                  ||
    .----------------------------------------------------------------.
    |                    N A T S  /  N G S (lattice)                 |
    `----------------------------------------------------------------'
       ||                            ||
    .-----------------------.  .-----------------------.
    | Player wasmCloud Host |  | Player wasmCloud Host |
    | .---.  .------------. |  | .---.  .------------. |
    | | H |  |  Frontiers | |  | | H |  |  Frontiers | |
    | `---'  |  Provider  | |  | `---'  |  Provider  | |
    |        `------------' |  |        `------------' |
    | .---.                 |  | .---.                 |
    | | H |                 |  | | H |                 |
    | `---'                 |  | `---'                 |
    `-----------------------'  `-----------------------'

H = Hero (wasmCloud Actor)
```

---
# frontiers.wasmcloud.dev
The central **wasmCloud Frontiers** website. Responsible for:

* Provisioning a new frontier, generating terrain, content, resources
* Monitoring lattice state events
* Monitoring _Frontier Events_, used for state aggregation and display
* Frontier state retention (persistent)
* Display/query/sort/filter frontiers in the game
    * Showing which ones are connected, under attack, under resourced, etc.

---
# The Game Rules

## Rule #1 - All Rules are Bogus

At this stage, everything we do in terms of modeling the game rules is arbitrary. But since
we need to start somewhere, we pick some _straw man_ rules that we'll delete, refine, or
enhance as we actually start playing the game.

## The Frontier

The frontier for each player is a grid of **50x50** squares. The center square(s) is the frontier's resource silo--the irresistable target for your enemies, the hordes.

## Resources

The following harvestable resources can be found throughout the map:

* Wood
* Grain
* Dairy
* Meat
* Iron (requires a mine)

## The Wormhole

At a random interval determined by the game host, a frontier will have one of its heros sucked into a wormhole and replaced by someone else's hero on the other side. A player may add a tag of `singularity` to _one_ and _only one_ of their heroes. A singularity hero is immune to wormholes and will not be pulled in.

---
# Game Rules - Building

The following structures can be built by heros using the "hero SDK" (actor interface) available with the game.

| Structure | Resource Used |
|---|---|
| Fence | Wood |
| Bulwark | Iron |
| Pit Trap | Wood |

