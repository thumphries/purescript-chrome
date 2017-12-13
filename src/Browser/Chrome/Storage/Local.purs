module Browser.Chrome.Storage.Local (
    STORAGE_LOCAL
  , get
  , set
  ) where

import Prelude
import Browser.Chrome.Storage as Storage
import Browser.Chrome.Storage.Internal as Internal
import Control.Monad.Aff (Aff, makeAff)
import Control.Monad.Eff (kind Effect)
import Control.Monad.Eff.Exception (error)
import Control.Monad.Error.Class (throwError)
import Data.Either (Either (..))
import Data.StrMap (StrMap)

-- | The effect associated with the use of local storage.
foreign import data STORAGE_LOCAL :: Effect

-- | Asynchronously set to local storage in Aff.
set :: forall a e. StrMap a -> Aff (storage :: STORAGE_LOCAL | e) Unit
set vals =
  makeAff $ \err success ->
    Internal.set Internal.local vals (err <<< error) success

-- | Asynchronously get from local storage in Aff, parsing the result in 'Get'.
get :: forall a e. Array String -> Storage.Get a -> Aff (storage :: STORAGE_LOCAL | e) a
get keys f = do
  gr <- get' keys
  case Storage.runGet gr f of
    Left err ->
      throwError (error err)
    Right a ->
      pure a

-- | Asynchronously get from local storage in Aff.
get' :: forall e. Array String -> Aff (storage :: STORAGE_LOCAL | e) Storage.GetResult
get' keys =
  map Storage.GetResult <<< makeAff $ \err success ->
    Internal.get Internal.local keys (err <<< error) success
