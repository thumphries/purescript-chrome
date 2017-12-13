module Browser.Chrome.Tabs.Internal where


import Prelude
import Control.Monad.Eff (Eff)


foreign import get :: forall e a. Int -> (String -> Eff e a) -> Eff e Unit

foreign import getWindowActive :: forall e a. Int -> (Int -> Eff e a) -> Eff e Unit

foreign import onActivated :: forall e. (Int -> Int -> Eff e Unit) -> Eff e Unit

foreign import onRemoved :: forall e. (Int -> Int -> Boolean -> Eff e Unit) -> Eff e Unit

foreign import onUpdated :: forall e. (Int -> String -> Eff e Unit) -> Eff e Unit

foreign import tab_id_none :: Int
