module Admin.Pages.Competition exposing (view)

import Admin.Messages exposing (Msg(..))
import Admin.Routing exposing (linkTo, competitionsPath)
import Admin.Types exposing (Competition, MailingList)
import Html exposing (Html, div, text, label, input, button, select, option)
import Html.Attributes exposing (type_, value, class, for, name, checked)


labelField : String -> String -> Html msg
labelField forValue textValue =
    div [ class "field-label is-normal" ]
        [ label [ for forValue, class "label" ]
            [ text textValue ]
        ]


textField : String -> String -> Html msg
textField nameValue textValue =
    div [ class "field-body" ]
        [ div [ class "control" ]
            [ input
                [ type_ "text", name nameValue, class "input", value textValue ]
                []
            ]
        ]


checkboxField : String -> Bool -> String -> Html msg
checkboxField nameValue checkedValue labelValue =
    div [ class "field-body" ]
        [ div [ class "field" ]
            [ div [ class "control" ]
                [ label [ class "checkbox" ]
                    [ input
                        [ type_ "checkbox", name nameValue, checked checkedValue ]
                        []
                    , text labelValue
                    ]
                ]
            ]
        ]


selectField : String -> List { a | id : String, name : String } -> Html msg
selectField nameValue data =
    div [ class "field-body" ]
        [ div [ class "field is-narrow" ]
            [ div [ class "control" ]
                [ div [ class "select is-fullwidth" ]
                    [ select [ name nameValue ] (List.map optionField data)
                    ]
                ]
            ]
        ]


optionField : { a | id : String, name : String } -> Html msg
optionField record =
    option [ value record.id ] [ text record.name ]


view : Competition -> List MailingList -> Html Msg
view competition mailingLists =
    div []
        [ div [ class "field is-horizontal" ]
            [ labelField "name" "Name"
            , textField "name" competition.name
            ]
        , div [ class "field is-horizontal" ]
            [ labelField "mailing_list_id" "Mailing List"
            , selectField "mailing_list_id" mailingLists
            ]
        , div [ class "field is-horizontal" ]
            [ div [ class "field-label" ] []
            , checkboxField "requires_entry_name" competition.requiresEntryName "This competition requires an entry name"
            ]
        , div [ class "field is-horizontal is-grouped" ]
            [ div [ class "field-label" ] []
            , div [ class "field-body" ]
                [ div [ class "control" ]
                    [ button [ class "button is-primary" ] [ text "Save" ]
                    , button ([ class "button is-text" ] ++ (linkTo competitionsPath)) [ text "Back" ]
                    ]
                ]
            ]
        ]
