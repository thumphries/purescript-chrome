module Browser.Chrome.Idle (
    IDLE
  , IdleState (..)
  , setDetectionInterval
  , queryState
  , onStateChanged
  ) where


import Prelude
import Browser.Chrome.Idle.Internal as Internal
import Control.Monad.Eff (Eff, kind Effect)
import Data.Int as Int
import Data.Maybe (Maybe (..))
import Data.Time.Duration (Seconds (..))


foreign import data IDLE :: Effect

data IdleState =
    Active
  | Idle
  | Locked
  | Other String

derive instance idleStateEq :: Eq IdleState

setDetectionInterval :: forall e. Seconds -> Eff (idle :: IDLE | e) Unit
setDetectionInterval (Seconds s) =
  case Int.fromNumber s of
    Just secs ->
      Internal.setDetectionInterval secs
    Nothing ->
      -- FIXME
      pure unit

queryState :: forall e f.
     Seconds
  -> (IdleState -> Eff (idle :: IDLE | e) Unit)
  -> Eff (idle :: IDLE | f) Unit
queryState (Seconds s) cb =
  case Int.fromNumber s of
    Just secs ->
      Internal.queryState secs (cb <<< toIdleState)
    Nothing ->
      -- FIXME
      pure unit

onStateChanged :: forall e f.
     (IdleState -> Eff (idle :: IDLE | e) Unit)
  -> Eff (idle :: IDLE | f) Unit
onStateChanged cb =
  Internal.onStateChanged $ cb <<< toIdleState

toIdleState :: String -> IdleState
toIdleState str =
  if str == Internal.idle_state_active then Active
    else if str == Internal.idle_state_idle   then Idle
    else if str == Internal.idle_state_locked then Locked
    else Other str
