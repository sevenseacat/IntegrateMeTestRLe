module Admin.Messages exposing (Msg(..))

import Admin.Types exposing (Response)
import Http
import Navigation exposing (Location)


type Msg
    = ChangeLocation String
    | OnLocationChange Location
    | UpdateName String
    | UpdateMailingListId String
    | UpdateRequireEntryName Bool
    | SaveCompetition
    | CompetitionSaved (Result Http.Error Response)
