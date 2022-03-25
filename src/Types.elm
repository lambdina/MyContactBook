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
    , editingMode : Bool}

type Msg
  = NameChanged String
  | EmailChanged String
  | PhoneNumberChanged String
  | FavoriteChangedOnEdit
  | FavoriteChangedOnSidebar Contact
  | SaveContact
  | ClickDetailContact Contact
  | SetEditMode