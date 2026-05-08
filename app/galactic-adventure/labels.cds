annotate CosmicService.Spacefarers with {
    name                    @title: 'Name';
    stardustCollection      @title: 'Stardust Collection';
    spacesuitColor          @title: 'Spacesuit Color';
    wormholeNavigationSkill @title: 'Wormhole Skill';
}

annotate CosmicService.Departments with {
    name @title: 'Department';
}

annotate CosmicService.Positions with {
    name @title: 'Position';
}

annotate CosmicService.Planets with {
    code        @title: 'Code';
    name        @title: 'Name';
    dangerLevel @title: 'Danger Level';
}
