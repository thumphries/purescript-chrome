module Browser.Chrome.Idle.Internal where


import Prelude
import Control.Monad.Eff (Eff)


foreign import idle_state_active :: String
foreign import idle_state_idle :: String
foreign import idle_state_locked :: String

foreign import setDetectionInterval :: forall e. Int -> Eff e Unit

foreign import queryState :: forall e f. Int -> (String -> Eff e Unit) -> Eff f Unit

foreign import onStateChanged :: forall e f. (String -> Eff e Unit) -> Eff f Unit
