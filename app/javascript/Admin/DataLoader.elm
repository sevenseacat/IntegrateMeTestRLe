module Admin.DataLoader exposing (loadCompetitions, loadMailingLists)

import Admin.Types exposing (Competition, MailingList)
import Json.Decode exposing (Decoder, decodeString, bool, int, list, string, nullable)
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
import Json.Decode.Extra exposing (date)


loadCompetitions : String -> Result String (List Competition)
loadCompetitions cs =
    decodeString (list competitionDecoder) cs


loadMailingLists : String -> Result String (List MailingList)
loadMailingLists lists =
    decodeString (list mailingListDecoder) lists


competitionDecoder : Decoder Competition
competitionDecoder =
    decode Competition
        |> required "id" int
        |> required "name" string
        |> required "requires_entry_name" bool
        |> required "mailing_list_id" (nullable string)
        |> required "entries_count" int
        |> required "created_at" date


mailingListDecoder : Decoder MailingList
mailingListDecoder =
    decode MailingList
        |> required "id" string
        |> required "name" string
