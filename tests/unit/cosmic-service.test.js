const cds = require("@sap/cds");

cds.test(process.cwd());

describe("CosmicService", () => {
  let srv;

  beforeAll(async () => {
    srv = await cds.connect.to("CosmicService");
  });

  const earthUser = {
    user: new cds.User({ id: "spacepilot", attr: { planetCode: "EARTH" } }),
  };
  const marsUser = {
    user: new cds.User({ id: "alien", attr: { planetCode: "MARS" } }),
  };

  it("User from EARTH reads only EARTH spacefarers", async () => {
    const result = await srv.tx(earthUser, (tx) => tx.read("Spacefarers"));
    expect(result.length).toBeGreaterThan(0);
    expect(result.some((s) => s.originPlanet_code !== "EARTH")).toBe(false);
  });

  it("User from MARS reads only MARS spacefarers", async () => {
    const result = await srv.tx(marsUser, (tx) => tx.read("Spacefarers"));
    expect(result.length).toBeGreaterThan(0);
    expect(result.some((s) => s.originPlanet_code !== "MARS")).toBe(false);
  });

  it("Before handler enhances stardustCollection and wormholeNavigationSkill", async () => {
    const initialSkillLevel = 5;
    const newSpacefarer = {
      name: "TestFarer",
      stardustCollection: initialSkillLevel,
      wormholeNavigationSkill: initialSkillLevel,
      spacesuitColor: "blue",
      originPlanet_code: "EARTH",
    };

    const created = await srv.tx(earthUser, (tx) =>
      tx.create("Spacefarers").entries(newSpacefarer),
    );

    const result = await srv.tx(earthUser, (tx) =>
      tx.read("Spacefarers").where({ name: "TestFarer" }),
    );

    expect(result[0].stardustCollection).toBeGreaterThan(initialSkillLevel);
    expect(result[0].wormholeNavigationSkill).toBeGreaterThan(
      initialSkillLevel,
    );
  });

  it("Before handler rejects spacefarer with negative stardustCollection", async () => {
    const invalidSkillLevel = -1;
    const invalidSpacefarer = {
      name: "BadFarer",
      stardustCollection: invalidSkillLevel,
      wormholeNavigationSkill: 5,
      spacesuitColor: "red",
      originPlanet_code: "EARTH",
    };

    await expect(
      srv.tx(earthUser, (tx) =>
        tx.create("Spacefarers").entries(invalidSpacefarer),
      ),
    ).rejects.toThrow();
  });

  it("Before handler rejects spacefarer with negative wormholeNavigationSkill", async () => {
    const invalidSkillLevel = -1;
    const invalidSpacefarer = {
      name: "BadFarer2",
      stardustCollection: 10,
      wormholeNavigationSkill: invalidSkillLevel,
      spacesuitColor: "green",
      originPlanet_code: "EARTH",
    };

    await expect(
      srv.tx(earthUser, (tx) =>
        tx.create("Spacefarers").entries(invalidSpacefarer),
      ),
    ).rejects.toThrow();
  });
});
