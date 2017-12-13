module Browser.Chrome.Storage (
  -- * Types
    GetResult (..)
  -- * Get monad
  , Get
  , runGet
  , getNumber
  , getInt
  , getString
  , getBoolean
  ) where


import Prelude
import Control.Monad.Except (runExcept)
import Control.Monad.Reader.Trans (ReaderT, runReaderT, ask)
import Control.Monad.Trans.Class (lift)
import Data.Bifunctor (lmap)
import Data.Either (Either)
import Data.Foreign (Foreign, F)
import Data.Foreign as Foreign
import Data.Maybe (maybe)
import Data.StrMap (StrMap)
import Data.StrMap as SM


newtype GetResult = GetResult (StrMap Foreign)

unGetResult :: GetResult -> StrMap Foreign
unGetResult (GetResult sm) =
  sm

newtype Get a = Get (ReaderT GetResult F a)

unGet :: forall a. Get a -> ReaderT GetResult F a
unGet (Get a) =
  a

derive instance functorGet :: Functor Get

instance applyGet :: Apply Get where
  apply (Get f) (Get g) = Get (apply f g)

instance applicativeGet :: Applicative Get where
  pure f = Get (pure f)

instance bindGet :: Bind Get where
  bind (Get f) g =
    Get <<< join $ map (unGet <<< g) f

instance monadGet :: Monad Get

runGet :: forall a. GetResult -> Get a -> Either String a
runGet gr (Get a) =
  lmap show <<< runExcept $ runReaderT a gr

getKey :: String -> Get Foreign
getKey key =
  Get $ ask >>= (lift <<< maybe (Foreign.fail (keyMissingMsg key)) pure <<< SM.lookup key <<< unGetResult)

liftF :: forall a. F a -> Get a
liftF f =
  Get (lift f)

getNumber :: String -> Get Number
getNumber key = do
  getKey key >>= liftF <<< Foreign.readNumber

getInt :: String -> Get Int
getInt key =
  getKey key >>= liftF <<< Foreign.readInt

getString :: String -> Get String
getString key =
  getKey key >>= liftF <<< Foreign.readString

getBoolean :: String -> Get Boolean
getBoolean key =
  getKey key >>= liftF <<< Foreign.readBoolean

keyMissingMsg :: String -> Foreign.ForeignError
keyMissingMsg k =
  Foreign.ForeignError $ "Key '" <> k <> "' was not found"
