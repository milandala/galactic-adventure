annotate CosmicServiceAdmin.Spacefarers with @(

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
            {Value: spacesuitColor_code},
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

annotate CosmicServiceAdmin.Spacefarers with @(Capabilities: {NavigationRestrictions: {
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

annotate CosmicServiceAdmin.Spacefarers with {
    originPlanet   @Core.Immutable
                   @(
        Common.ValueList               : {
            Label         : 'Select Planet for New Spacefarer',
            CollectionPath: 'Planets',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: originPlanet_code,
                    ValueListProperty: 'code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'dangerLevel'
                }
            ]
        },
        Common.ValueListWithFixedValues: true,
        Common.Text                    : originPlanet.name,
        Common.TextArrangement         : #TextOnly
    );

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

annotate CosmicServiceAdmin.Departments with @(
    Capabilities.InsertRestrictions.Insertable: false,
    Capabilities.UpdateRestrictions.Updatable : false,
    Capabilities.DeleteRestrictions.Deletable : false
);

annotate CosmicServiceAdmin.Positions with @(
    Capabilities.InsertRestrictions.Insertable: false,
    Capabilities.UpdateRestrictions.Updatable : false,
    Capabilities.DeleteRestrictions.Deletable : false
);

annotate CosmicServiceAdmin.Planets with @(
    Capabilities.InsertRestrictions.Insertable: false,
    Capabilities.UpdateRestrictions.Updatable : false,
    Capabilities.DeleteRestrictions.Deletable : false
);
