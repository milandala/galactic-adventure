annotate CosmicService.Spacefarers with @(

    UI.HeaderInfo               : {
        TypeName      : 'Spacefarer',
        TypeNamePlural: 'Spacefarers',
    },

    UI.LineItem                 : [
        {Value: name},
        {Value: stardustCollection},
        {
            Value: spacesuitColor.name,
            Label: 'Spacesuit color'
        },
    ],

    UI.SelectionFields          : [
        stardustCollection,
        spacesuitColor_code
    ],

    UI.FieldGroup #CosmicDetails: {
        Label: 'Cosmic Details',
        Data : [
            {Value: name},
            {Value: stardustCollection},
            {
                Value: spacesuitColor.name,
                Label: 'Spacesuit color'
            },
            {Value: wormholeNavigationSkill},
            {
                Value: department.name,
                Label: 'Department'
            },
            {
                Value: position.name,
                Label: 'Position'
            },
            {
                Value: originPlanet.name,
                Label: 'Origin planet'
            }
        ]
    },

    UI.Facets                   : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Cosmic Details',
        Target: '@UI.FieldGroup#CosmicDetails'
    }]
);

annotate CosmicService.Spacefarers with @(Capabilities: {NavigationRestrictions: {
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

annotate CosmicService.Spacefarers with {
    originPlanet   @Core.Immutable;
    spacesuitColor @(
        Common.Label                   : 'Spacesuit color',
        Common                         : {
            Text           : spacesuitColor.name,
            TextArrangement: #TextOnly
        },
        Common.ValueListWithFixedValues: true,
        Common.ValueList               : {
            Label         : 'Spacesuit Color',
            CollectionPath: 'SpacesuitColors',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: spacesuitColor_code,
                    ValueListProperty: 'code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                }
            ]
        }
    );
}

annotate CosmicService.Departments with @(
    Capabilities.InsertRestrictions.Insertable: false,
    Capabilities.UpdateRestrictions.Updatable : false,
    Capabilities.DeleteRestrictions.Deletable : false
);

annotate CosmicService.Positions with @(
    Capabilities.InsertRestrictions.Insertable: false,
    Capabilities.UpdateRestrictions.Updatable : false,
    Capabilities.DeleteRestrictions.Deletable : false
);

annotate CosmicService.Planets with @(
    Capabilities.InsertRestrictions.Insertable: false,
    Capabilities.UpdateRestrictions.Updatable : false,
    Capabilities.DeleteRestrictions.Deletable : false
);
