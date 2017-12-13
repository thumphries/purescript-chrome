module Browser.Chrome.Storage.Internal (
  -- * Storage areas
    StorageArea
  , local
  , sync
  -- * Foreign primitives
  , get
  , set
  ) where


import Prelude
import Control.Monad.Eff (Eff)
import Data.Foreign (Foreign)
import Data.StrMap (StrMap)


foreign import data StorageArea :: Type
foreign import local :: StorageArea
foreign import sync :: StorageArea

-- | Asynchronously get from a storage area.
foreign import get :: forall e f b.
     StorageArea
  -> Array String
  -> (String -> Eff f b)
  -> (StrMap Foreign -> Eff f b)
  -> Eff e Unit

-- | Asynchronously set to a storage area.
foreign import set :: forall e f a.
     StorageArea
  -> StrMap a
  -> (String -> Eff f Unit)
  -> (Unit -> Eff f Unit)
  -> Eff e Unit
