annotate CosmicServiceAdmin.Planets with @(

    UI.HeaderInfo               : {
        TypeName      : 'Planet',
        TypeNamePlural: 'Planets'
    },

    UI.LineItem                 : [
        {Value: code},
        {Value: name},
        {Value: dangerLevel}
    ],

    UI.SelectionFields          : [
        code,
        name,
        dangerLevel
    ],

    UI.FieldGroup #PlanetDetails: {
        Label: 'Planet Details',
        Data : [
            {Value: code},
            {Value: name},
            {Value: dangerLevel}
        ]
    },

    UI.Facets                   : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Planet Details',
        Target: '@UI.FieldGroup#PlanetDetails'
    }]
);

annotate CosmicServiceAdmin.Planets with @(Capabilities: {NavigationRestrictions: {
    $Type               : 'Capabilities.NavigationRestrictionsType',
    RestrictedProperties: [{
        $Type             : 'Capabilities.NavigationPropertyRestriction',
        NavigationProperty: DraftAdministrativeData,
        FilterRestrictions: {
            $Type     : 'Capabilities.FilterRestrictionsType',
            Filterable: false,
        },
    }, ],
}, });
