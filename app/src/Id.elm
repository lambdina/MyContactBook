module Id exposing (..)

import UUID

generateId : String -> String
generateId contactInfo = UUID.forName contactInfo UUID.oidNamespace
    |> UUID.toString