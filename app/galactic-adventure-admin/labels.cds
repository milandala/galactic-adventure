annotate CosmicServiceAdmin.Spacefarers with {
    name                    @title: 'Name';
    stardustCollection      @title: 'Stardust collection';
    wormholeNavigationSkill @title: 'Wormhole skill';
}

annotate CosmicServiceAdmin.Departments with {
    name @title: 'Name';
    role @title: 'Role';
}

annotate CosmicServiceAdmin.Positions with {
    name         @title: 'Name';
    gravityLevel @title: 'Gravity level';
}

annotate CosmicServiceAdmin.Planets with {
    code        @title: 'Code';
    name        @title: 'Name';
    dangerLevel @title: 'Danger level';
}

annotate CosmicServiceAdmin.SpacesuitColors with {
    code @title: 'Code';
    name @title: 'Name';
}
