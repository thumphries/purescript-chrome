module Browser.Chrome.Windows (
  -- * Types
    WINDOWS
  , WindowId (..)
  -- * Events
  , onFocusChanged
  ) where


import Prelude
import Browser.Chrome.Windows.Internal as Internal
import Control.Monad.Eff (Eff, kind Effect)
import Data.Maybe (Maybe (..))


foreign import data WINDOWS :: Effect

newtype WindowId = WindowId Int

onFocusChanged :: forall e.
     (Maybe WindowId -> Eff (windows :: WINDOWS | e) Unit)
  -> Eff (windows :: WINDOWS | e) Unit
onFocusChanged cb =
  Internal.onFocusChanged $ \wid ->
    if wid == Internal.window_id_none
      then cb Nothing
      else cb (Just (WindowId wid))
