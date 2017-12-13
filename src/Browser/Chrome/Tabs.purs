module Browser.Chrome.Tabs (
  -- * Types
    TABS
  , TabId (..)
  -- * Methods
  , getUrl
  , getWindowActive
  -- * Events
  , onActivated
  , onRemoved
  , onUpdated
  ) where


import Prelude
import Browser.Chrome.Tabs.Internal as Internal
import Browser.Chrome.Windows (WindowId (..))
import Control.Monad.Aff (Aff, makeAff)
import Control.Monad.Eff (Eff, kind Effect)


foreign import data TABS :: Effect

newtype TabId = TabId Int

derive instance tabIdEq :: Eq TabId

getUrl :: forall e. TabId -> Aff (tabs :: TABS | e) String
getUrl (TabId tid) =
  makeAff $ \_err success ->
    Internal.get tid success

-- FIXME this should just return a Tab
getWindowActive :: forall e. WindowId -> Aff (tabs :: TABS | e) TabId
getWindowActive (WindowId wid) =
  makeAff $ \err success ->
    Internal.getWindowActive wid (success <<< TabId)

onActivated :: forall e.
     (TabId -> WindowId -> Eff (tabs :: TABS | e) Unit)
  -> Eff (tabs :: TABS | e) Unit
onActivated cb =
  Internal.onActivated $ \tid wid ->
    cb (TabId tid) (WindowId wid)

onRemoved :: forall e.
     (TabId -> WindowId -> Boolean -> Eff (tabs :: TABS | e) Unit)
  -> Eff (tabs :: TABS | e) Unit
onRemoved cb =
  Internal.onRemoved $ \tid wid wcl ->
    cb (TabId tid) (WindowId wid) wcl

onUpdated :: forall e.
     (TabId -> String -> Eff (tabs :: TABS | e) Unit)
  -> Eff (tabs :: TABS | e) Unit
onUpdated cb =
  Internal.onUpdated $ \tid url ->
    cb (TabId tid) url
