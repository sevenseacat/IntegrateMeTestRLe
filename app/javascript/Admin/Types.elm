module Admin.Types exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)


type alias Competition =
    { id : Int
    , name : String
    , requiresEntryName : Bool
    , mailingListId : Maybe String
    , entryCount : Int
    , createdOn : Date
    }


type alias Errors =
    Dict String (List String)


type alias MailingList =
    { id : String
    , name : String
    }
