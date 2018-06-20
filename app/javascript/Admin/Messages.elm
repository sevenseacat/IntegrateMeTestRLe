module Admin.Messages exposing (Msg(..))

import Navigation exposing (Location)


type Msg
    = ChangeLocation String
    | OnLocationChange Location
