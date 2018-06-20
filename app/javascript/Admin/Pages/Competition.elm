module Admin.Pages.Competition exposing (..)

import Admin.Competition exposing (Competition)
import Admin.Messages exposing (Msg(..))
import Html exposing (Html, div, text, label, input, button)
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


view : Competition -> Html Msg
view competition =
    div []
        [ div [ class "field is-horizontal" ]
            [ labelField "name" "Name"
            , textField "name" competition.name
            ]
        , div [ class "field is-horizontal" ]
            [ div [ class "field-label" ] []
            , checkboxField "requires_entry_name" competition.requiresEntryName "This competition requires an entry name"
            ]
        , div [ class "field is-horizontal" ]
            [ div [ class "field-label" ] []
            , div [ class "field-body" ]
                [ div [ class "control" ]
                    [ button [ class "button is-primary" ] [ text "Save" ]
                    ]
                ]
            ]
        ]
