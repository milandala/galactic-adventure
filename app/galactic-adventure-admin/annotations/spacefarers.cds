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
        {
            Value: originPlanet.name,
            Label: 'Origin planet'
        },
    ],

    UI.SelectionFields          : [
        stardustCollection,
        spacesuitColor_code,
        originPlanet_code
    ],

    UI.FieldGroup #CosmicDetails: {
        Label: 'Cosmic Details',
        Data : [
            {Value: name},
            {Value: stardustCollection},
            {Value: wormholeNavigationSkill},
            {Value: spacesuitColor_code},
            {Value: department_ID},
            {Value: position_ID},
            {
                Value: originPlanet_code,
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
    originPlanet   @(
        Common.Label                   : 'Origin planet',
        Common.ValueList               : {
            Label         : 'Select Planet for New Spacefarer',
            CollectionPath: 'Planets',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: originPlanet_code,
                    ValueListProperty: 'code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
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

    department     @(
        Common.Label                   : 'Department',
        Common                         : {
            Text           : department.name,
            TextArrangement: #TextOnly
        },
        Common.ValueListWithFixedValues: true,
        Common.ValueList               : {
            Label         : 'Department',
            CollectionPath: 'Departments',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: department_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                }
            ]
        }
    );

    position       @(
        Common.Label                   : 'Position',
        Common                         : {
            Text           : position.name,
            TextArrangement: #TextOnly
        },
        Common.ValueListWithFixedValues: true,
        Common.ValueList               : {
            Label         : 'Position',
            CollectionPath: 'Positions',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: position_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                }
            ]
        }
    );
}
