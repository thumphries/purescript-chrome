module Browser.Chrome.Windows.Internal where


import Prelude
import Control.Monad.Eff (Eff)


foreign import window_id_none :: Int

foreign import onFocusChanged :: forall e. (Int -> Eff e Unit) -> Eff e Unit
