port module Contact exposing (..)
import Types as T exposing (..)
import Id exposing (generateId)
import Json.Decode.Pipeline as D
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (..)
import Json.Decode as D
import Json.Encode as E
import ContactList exposing (viewContactList)
import EditContact exposing (viewForm)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    T.NameChanged name ->
      ( {model | currentContact = setName name model.currentContact}
      , Cmd.none
      )

    T.EmailChanged email ->
      ( {model | currentContact = setEmail email model.currentContact}
      , Cmd.none
      )
    T.PhoneNumberChanged phoneNumber ->
        ( {model | currentContact = setPhoneNumber phoneNumber model.currentContact}
        , Cmd.none
        )
    T.FavoriteChanged ->
      ( {model | currentContact = setFavorite model.currentContact}
      , Cmd.none)
    T.SaveContact ->
        ( {model | currentContact = setContactId model.currentContact
                 , allContacts = unique (model.currentContact :: model.allContacts)
                 , editingMode = False }
        , Cmd.none
        )
    T.ClickDetailContact contact ->
      ( {model | currentContact = contact, editingMode = False}
      , Cmd.none)
    T.SetEditMode bool ->
      ( {model | editingMode = bool}
      , Cmd.none)

unique : List a -> List a
unique l = 
    let
        incUnique : a -> List a -> List a
        incUnique elem lst = 
            case List.member elem lst of
                True -> lst
                False -> elem :: lst
    in
        List.foldr incUnique [] l

setName : String -> Contact -> Contact
setName name contact = {contact | name = name}

setEmail : String -> Contact -> Contact
setEmail email contact = {contact | email = email}

setPhoneNumber : String -> Contact -> Contact
setPhoneNumber phoneNumber contact = {contact | phoneNumber = phoneNumber}

setFavorite : Contact -> Contact
setFavorite contact = {contact | isFavorite = not contact.isFavorite}

setContactId : Contact -> Contact
setContactId contact = {contact | contactId = generateId (contactInfo contact) }

viewRoot : Model -> Html Msg
viewRoot model =
    Html.div [class "bg-gray-50 bg-opacity-50 divide-x-2"] [
      div [ class "flex" ] [
        viewContactList model,
        div [ class "flex justify-center items-center pr-12 w-full" ] [
          if model.editingMode == True then
            viewForm model
          else viewContact model.currentContact
        ]
      ]
    ]

viewContact : Contact -> Html Msg
viewContact contact =
  div [ class "flex flex-col bg-white shadow-md rounded-md w-full max-w-md" ] [
    Html.div [ class "p-4 bg-gray-100 border-t-2 border-purple-600 bg-opacity-5 divide-y-2 space-y-2.5"] [
        Html.div [ class "max-w-sm mx-auto md:w-full md:mx-0" ] [
          button
            [ class "text-purple-600 font-medium text-sm"
            , onClick (T.SetEditMode True) ] [ text "Edit" ],
          Html.div [ class "grid grid-cols-1 place-items-center space-y-4" ] [
            Html.img [alt "profile", src "https://oahurcd.org/wp-content/uploads/2021/12/profile-avatar.jpg", class "mx-auto object-cover rounded-full h-20 w-20"] [],
            div [ class "flex" ] [
              if contact.isFavorite == True then
                i [ class "fa fa-star pr-2 pt-1" ] []
              else i [] []
              , h3 [ class "text-xl text-gray-900" ] [ text contact.name ]
            ]
          ]
        ]
        , div [] [
          p [ class "text-xs px-4 py-4" ] [ text "Email"],
          p [ class "text-xs px-4 text-purple-600" ] [ text contact.email ]
        ]
        , div [] [
          p [ class "text-xs px-4 py-4" ] [ text "phone"],
          p [ class "text-xs px-4 text-purple-600" ] [ text contact.phoneNumber ]
        ]
    ]
  ]

getName : Contact -> String
getName contact = contact.name

getEmail : Contact -> String
getEmail contact = contact.email

getPhoneNumber : Contact -> String
getPhoneNumber contact = contact.phoneNumber

contactInfo : Contact -> String
contactInfo contact = contact.name ++ contact.email ++ contact.phoneNumber

-- PORTS


port setStorage : E.Value -> Cmd msg


-- We want to `setStorage` on every update, so this function adds
-- the setStorage command on each step of the update function.
--
-- Check out index.html to see how this is handled on the JS side.


-- JSON ENCODE/DECODE


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg oldModel =
  let
    ( newModel, cmds ) = update msg oldModel
  in
  ( newModel
  , Cmd.batch [ setStorage (encode newModel), cmds ]
  )

encodeSingleContact : Contact -> E.Value
encodeSingleContact contact = E.object
    [ ("name", E.string contact.name)
    , ("email", E.string contact.email)
    , ("phoneNumber", E.string contact.phoneNumber)
    , ("isFavorite", E.bool contact.isFavorite)
    , ("contactId", E.string contact.contactId)
    ]


encode : Model -> E.Value
encode model = E.object
    [ ("currentContact", (encodeSingleContact model.currentContact))
    , ("allContacts", E.list (\x -> encodeSingleContact x) model.allContacts)
    ]

decoder : D.Decoder Model
decoder =
  D.succeed Model
    |> D.required "currentContact" decodeContact
    |> D.required "allContacts" (D.list decodeContact)
    |> D.hardcoded True

decodeContact : D.Decoder Contact
decodeContact = D.map5 Contact
    (D.field "name"        D.string)
    (D.field "email"       D.string)
    (D.field "phoneNumber" D.string)
    (D.field "isFavorite"  D.bool)
    (D.field "contactId"   D.string)

init : E.Value -> ( Model, Cmd Msg )
init flags =
  (
    case D.decodeValue decoder flags of
      Ok model -> model
      Err _ -> { allContacts = []
               , currentContact = { name = "", email = "", phoneNumber = "", isFavorite = False, contactId =""}
               , editingMode = True}
  ,
    Cmd.none
  )