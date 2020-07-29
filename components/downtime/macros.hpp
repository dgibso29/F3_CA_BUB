#include "../../macros.hpp"

#define SHOULD_CONTINUE f_var_downtimeExperienceActive

#define DOWNTIME_WAIT_TIME 10

#define IS_UNCONSCIOUS(UNIT)        (UNIT getVariable ["ACE_isUnconscious", false])
#define PLAYER_IS_AWAITING_RESPAWN  (missionNamespace getVariable ["f_var_playerHasBeenKilled", false])
#define PLAYER_IS_DOWN              (IS_UNCONSCIOUS(player) or {!alive player} or {PLAYER_IS_AWAITING_RESPAWN})
#define PLAYER_IS_GHOST             (PLAYER_IS_AWAITING_RESPAWN and {alive player})
