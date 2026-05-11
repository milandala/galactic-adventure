using {galactic as db} from '../db/schema';

@requires: 'admin'
service CosmicServiceAdmin {

  @cds.query.limit: {
    default: 10,
    max    : 20
  }
  @odata.draft.enabled
  entity Spacefarers     as projection on db.Spacefarers;

  @odata.draft.enabled
  entity Departments     as projection on db.Departments;

  @odata.draft.enabled
  entity Positions       as projection on db.Positions;

  @odata.draft.enabled
  entity Planets         as projection on db.Planets;

  @odata.draft.enabled
  entity SpacesuitColors as projection on db.SpacesuitColors;
}
