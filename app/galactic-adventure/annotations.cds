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
            {Value: wormholeNavigationSkill},
            {Value: spacesuitColor_code},
            {Value: department_ID},
            {Value: position_ID}
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
