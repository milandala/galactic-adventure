annotate CosmicService.Spacefarers with @(


    UI.HeaderInfo               : {
        TypeName      : 'Spacefarer',
        TypeNamePlural: 'Spacefarers',
    },

    UI.LineItem                 : [
        {
            Value: name,
            Label: 'Name'
        },
        {
            Value: stardustCollection,
            Label: 'Stardust Collection'
        },
        {
            Value: spacesuitColor,
            Label: 'Spacesuit Color'
        }
    ],

    UI.SelectionFields          : [
        stardustCollection,
        spacesuitColor
    ],

    UI.FieldGroup #CosmicDetails: {
        Label: 'Cosmic Details',
        Data : [
            {
                Value: name,
                Label: 'Name'
            },
            {
                Value: stardustCollection,
                Label: 'Stardust Collection'
            },
            {
                Value: spacesuitColor,
                Label: 'Spacesuit Color'
            },
            {
                Value: wormholeNavigationSkill,
                Label: 'Wormhole Skill'
            },
            {
                Value: department.name,
                Label: 'Department'
            },
            {
                Value: position.name,
                Label: 'Position'
            },
            {
                Value: originPlanet_code,
                Label: 'Origin Planet'
            },
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
    originPlanet @Core.Immutable;
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
