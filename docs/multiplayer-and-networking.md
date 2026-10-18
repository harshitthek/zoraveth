# Multiplayer and Networking — Long-Term Specification

**Status:** vision and design constraints only. No online multiplayer is in the first prototype.

## Intended play modes
1. **Personal World:** personal progression/world experience; local hosting by default; invite-only co-op with friends; possible future migration to dedicated hosting.
2. **Shared World:** dedicated servers, shared world state, player communities and lasting world history.
3. Character/core progression should carry between modes where appropriate, while world-specific quests, discoveries and changes remain distinct enough to avoid inconsistent state.

Exact transfer rules and persistence ownership are not yet finalized.

## Multiplayer feature direction
- Solo-friendly exploration and progression.
- Meaningful co-op for bosses, dungeons, guild challenges and world events.
- Parties can use optional matchmaking and open-world co-op.
- Hybrid loot: personal progression/drops where appropriate, transparent rules for valuable shared loot.
- Multiple group sizes should support balanced prestige.
- Arena/duel PvP is opt-in; contested zones/events have clear warnings and anti-exploit safeguards.
- Crime/bounty systems may exist in selected contexts.
- Guilds can support cooperative progression, governance, strongholds/events and influence with safeguards against permanent monopolies.

## Authority and security
Before networked gameplay, document:
- Who owns authoritative movement, combat, loot, economy and world-state decisions.
- Which client requests are validated and how.
- How cheating, replay/spam, disconnects, desynchronization and malicious clients are handled.
- What data persists on a host versus dedicated server.
- How reconnection and state recovery work.
Never trust a client to unilaterally decide important shared-world outcomes.

## Feasibility gates
Do not design for "thousands of players" by assumption. Prototype two players first, measure network/CPU use, test disconnect/reconnect, then evaluate more players and server architecture.

Before launch planning, estimate hosting, moderation, security, backups, observability, incident response and ongoing operating costs.

## Future tests
- Two clients can join and leave a test session.
- Authoritative state remains consistent under ordinary latency.
- Invalid client requests are rejected.
- Disconnect/reconnect behavior is predictable.
- Personal and shared world state cannot accidentally overwrite one another.
- Dedicated server can run without graphical rendering if the chosen architecture supports it.
