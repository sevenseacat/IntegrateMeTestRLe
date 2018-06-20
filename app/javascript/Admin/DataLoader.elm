module Admin.DataLoader exposing (loadCompetitions, loadMailingLists, encodeCompetition, responseDecoder)

import Admin.Types exposing (Competition, MailingList, Response, Errors)
import Json.Decode exposing (Decoder, field, decodeString, bool, int, list, string, nullable, dict)
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
import Json.Decode.Extra exposing (date)
import Json.Encode as Encode


encodeCompetition : Competition -> Encode.Value
encodeCompetition c =
    Encode.object
        [ ( "competition"
          , Encode.object
                [ ( "name", Encode.string c.name )
                , ( "requires_entry_name", Encode.bool c.requiresEntryName )
                , ( "mailing_list_id"
                  , case c.mailingListId of
                        Just v ->
                            Encode.string v

                        Nothing ->
                            Encode.null
                  )
                ]
          )
        ]


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


responseDecoder : Decoder Response
responseDecoder =
    decode Response
        |> required "competition" (nullable competitionDecoder)
        |> required "errors" (dict (list string))
