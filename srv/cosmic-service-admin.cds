using {galactic as db} from '../db/schema';


service CosmicServiceAdmin @(requires: 'authenticated-user') {

  @restrict       : [
    {
      grant: '*',
      to   : 'admin'
    },
    {
      grant: [
        'READ',
        'CREATE',
        'UPDATE',
        'DELETE'
      ],
      to   : 'authenticated-user',
      where: 'originPlanet.code = $user.planetCode'
    }
  ]
  @cds.query.limit: {
    default: 10,
    max    : 20
  }
  @odata.draft.enabled
  entity Spacefarers     as projection on db.Spacefarers;

  @restrict: [
    {
      grant: '*',
      to   : 'admin'
    },
    {
      grant: 'READ',
      to   : 'authenticated-user'
    }
  ]
  @odata.draft.enabled
  entity Departments     as projection on db.Departments;

  @restrict: [
    {
      grant: '*',
      to   : 'admin'
    },
    {
      grant: 'READ',
      to   : 'authenticated-user'
    }
  ]
  @odata.draft.enabled
  entity Positions       as projection on db.Positions;

  @restrict: [
    {
      grant: '*',
      to   : 'admin'
    },
    {
      grant: 'READ',
      to   : 'authenticated-user'
    }
  ]
  @odata.draft.enabled
  entity Planets         as projection on db.Planets;

  @restrict: [
    {
      grant: '*',
      to   : 'admin'
    },
    {
      grant: 'READ',
      to   : 'authenticated-user'
    }
  ]
  @odata.draft.enabled
  entity SpacesuitColors as projection on db.SpacesuitColors;
}
