module Admin.Types exposing (..)

import Date exposing (Date)


type alias Competition =
    { id : Int
    , name : String
    , requiresEntryName : Bool
    , mailingListId : Maybe String
    , entryCount : Int
    , createdOn : Date
    }


type alias MailingList =
    { id : String
    , name : String
    }
