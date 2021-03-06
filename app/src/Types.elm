module Types exposing (..)

-- MODEL
type alias Contact =
  { name : String
  , email : String
  , phoneNumber : String
  , isFavorite : Bool
  , contactId : String
  }

type alias Model =
    { currentContact : Contact
    , allContacts : List Contact
    , editingMode : Bool
    , filterByFavorites : Bool
    , emailIsValid : Bool
    , phoneNumberIsValid : Bool}

type Msg
  = NameChanged String
  | EmailChanged String
  | PhoneNumberChanged String
  | FavoriteChangedOnEdit
  | FavoriteChangedOnSidebar Contact
  | SaveContact
  | NewForm
  | ClickDetailContact Contact
  | SetEditMode
  | FilterByFavoriteMode